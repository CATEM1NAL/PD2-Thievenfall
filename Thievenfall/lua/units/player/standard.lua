Hooks:OverrideFunction(PlayerStandard, "_find_pickups", function(self, t)
  local pickups = World:find_units_quick("sphere", self._unit:movement():m_pos(), self._pickup_area, self._slotmask_pickups)
  for _, pickup in ipairs(pickups) do
    if pickup:pickup() and pickup:pickup():pickup(self._unit) then
      for id, weapon in pairs(self._unit:inventory():available_selections()) do
        managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
      end
    end
  end
end)

Hooks:PostHook(PlayerStandard, "init", "CrimDusk_InitPlayerStandard", function(self)
  self._slotmask_bullet_impact_targets = managers.slot:get_mask("bullet_impact_targets") + 3
end)

-- Melee is treated as its own weapon slot
Hooks:OverrideFunction(PlayerStandard, "_check_action_melee", function(self, t, input)
  local CanMelee = not self._state_data.melee_attack_allowed_t and not self._state_data.melee_repeat_expire_t

  -- Attack buffering
  if self._state_data.melee_attack_wanted and CanMelee then
    self._state_data.melee_attack_wanted = nil
    self:_do_action_melee(t, input)
  return end

  -- Unequip buffering
  if self._state_data.buffer_melee_unequip and CanMelee then
    self._state_data.buffer_melee_unequip = nil
    self._state_data.melee_active = nil
    if not self:in_melee() then self:_start_action_melee(t, input) end -- hacky solution to fix anim bugs
    self:_interupt_action_melee(t)
    if self._change_weapon_data then self:_start_action_equip_weapon(t) end
  return end

  local InvalidState = self:_interacting() or self:is_deploying()
  local action_wanted = not InvalidState and (self._state_data.melee_active or input.btn_melee_press)
  if not action_wanted then return end

  -- Put melee away on button press
  if self._state_data.melee_active and input.btn_melee_press then
    if self._state_data.buffer_melee_unequip then
      self._change_weapon_data = nil
      self._state_data.buffer_melee_unequip = nil
    else
      self._change_weapon_data = { selection_wanted = (Utils:IsCurrentWeaponPrimary() and 2 or 1) }
      self._state_data.buffer_melee_unequip = true
    end
  return

  -- Click (or hold) to attack
  elseif self._state_data.melee_active and input.btn_primary_attack_state and not self._state_data.melee_attack_wanted then
    if self._state_data.melee_attack_allowed_t then self._state_data.melee_attack_wanted = true
    elseif not self._state_data.melee_repeat_expire_t then self:_do_action_melee(t, input) end
  return end

  local action_forbidden = not self:_melee_repeat_allowed() or self._use_item_expire_t or self:_changing_weapon() or self:_interacting() or self:_is_throwing_projectile() or self:_is_using_bipod() or self:is_shooting_count()
  if action_forbidden then return end

  if not self._state_data.melee_active then
    DelayedCalls:Remove("CrimDusk_MeleeToSprintAnim")
    self._state_data.melee_active = true
  end

  self:_start_action_melee(t, input)
  return true
end)

Hooks:PostHook(PlayerStandard, "_start_action_equip_weapon", "CrimDusk_PostEquipWeapon", function(self)
  -- Could do with cleaning up a bit
  local tweak = self._equipped_unit:base():weapon_tweak_data()
  DelayedCalls:Add("CrimDusk_MeleeToSprintAnim", tweak.timers.equip or 0.7, function()
    local PlayerState = managers.player:player_unit():movement():current_state()
    if PlayerState:running() and not PlayerState._equipped_unit:base():run_and_shoot_allowed() then
      PlayerState._ext_camera:play_redirect(PlayerState:get_animation("start_running"))
    end
  end)
end)

Hooks:PreHook(PlayerStandard, "_check_action_equip", "CrimDusk_PreCheckEquipStandard", function(self, t, input)
  if input.btn_primary_choice and self._state_data.melee_active then
    self._change_weapon_data = { selection_wanted = input.btn_primary_choice }
    self._state_data.buffer_melee_unequip = true
  return false end
end)

-- Place deployables while meleeing
Hooks:OverrideFunction(PlayerStandard, "_check_use_item", function(self, t, input)
  local pressed, released, holding

  if self._use_item_expire_t and not self._interact_expire_t then
    pressed, released, holding = self:_check_tap_to_interact_inputs(t, input.btn_use_item_press, input.btn_use_item_release, input.btn_use_item_state)
  else pressed, released, holding = input.btn_use_item_press, input.btn_use_item_release, input.btn_use_item_state end

  local new_action
  if pressed then
    local action_forbidden = self._use_item_expire_t or self._equipping_mask or self:_interacting() or self:_is_throwing_projectile()
    if not action_forbidden and managers.player:can_use_selected_equipment(self._unit) then
      self:_start_action_use_item(t)
      new_action = true
    end
  end

  if released then self:_interupt_action_use_item() end
  return new_action
end)

-- Movement tweaks
Hooks:OverrideFunction(PlayerStandard, "_start_action_melee", function(self, t, input, instant)
  self._equipped_unit:base():tweak_data_anim_stop("fire")
  self:_interupt_action_reload(t)
  self:_interupt_action_steelsight(t)
  self:_interupt_action_charging_weapon(t)

  self._state_data.melee_charge_wanted = nil
  self._state_data.meleeing = true
  self._state_data.melee_start_t = nil

  self:_stance_entered()

  if self._state_data.melee_global_value then self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 0) end

  local melee_entry = managers.blackmarket:equipped_melee_weapon()
  self._state_data.melee_global_value = tweak_data.blackmarket.melee_weapons[melee_entry].anim_global_param
  self._camera_unit:anim_state_machine():set_global(self._state_data.melee_global_value, 1)

  local current_state_name = self._camera_unit:anim_state_machine():segment_state(self:get_animation("base"))
  local attack_allowed_expire_t = tweak_data.blackmarket.melee_weapons[melee_entry].attack_allowed_expire_t or 0.15
  self._state_data.melee_attack_allowed_t = t + (current_state_name ~= self:get_animation("melee_attack_state") and attack_allowed_expire_t or 0)

  self._ext_network:send("sync_melee_start", 0)

  if current_state_name == self:get_animation("melee_attack_state") then
    self._ext_camera:play_redirect(self:get_animation("melee_charge"))
  return end

  local offset
  if current_state_name == self:get_animation("melee_exit_state") then
    local segment_relative_time = self._camera_unit:anim_state_machine():segment_relative_time(self:get_animation("base"))
    offset = (1 - segment_relative_time) * 0.9
  end

  offset = math.max(offset or 0, attack_allowed_expire_t)
  self._ext_camera:play_redirect(self:get_animation("melee_enter"), nil, offset)
end)

Hooks:OverrideFunction(PlayerStandard, "_start_action_running", function(self, t)
  if self._slowdown_run_prevent then self._running_wanted = false return end
  if not self._move_dir then self._running_wanted = true return end
  if self:on_ladder() or self:_on_zipline() then return end

  if self._shooting and not self._equipped_unit:base():run_and_shoot_allowed() or self._use_item_expire_t or self._state_data.in_air or self:_is_charging_weapon() then
    self._running_wanted = true
  return end

  if self._state_data.ducking and not self:_can_stand() then self._running_wanted = true return end
  if not self:_can_run_directional() then return end

  self._running_wanted = false

  if managers.player:get_player_rule("no_run") then return end

  if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing(self._state_data.shake_player_start_running)) and self._setting_use_headbob then
    self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running", 0.75)
  end

  self:set_running(true)

  self._end_running_expire_t = nil
  self._start_running_t = t
  self._play_stop_running_anim = nil

  local instant_hit = tweak_data.blackmarket.melee_weapons[managers.blackmarket:equipped_melee_weapon()].instant
  if (not self:_is_meleeing() or instant_hit) and (not self:_is_reloading() or not self.RUN_AND_RELOAD) and not self:_is_throwing_projectile() then
    if not self._equipped_unit:base():run_and_shoot_allowed() then self._ext_camera:play_redirect(self:get_animation("start_running"))
    else self._ext_camera:play_redirect(self:get_animation("idle")) end
  end

  if not self.RUN_AND_RELOAD then self:_interupt_action_reload(t) end

  self:_interupt_action_steelsight(t)
  self:_interupt_action_ducking(t)
end)

Hooks:OverrideFunction(PlayerStandard, "_end_action_running", function(self, t)
  if not self._end_running_expire_t then
    self._end_running_expire_t = t + 0.1
  
    if self:_is_meleeing() or self:_is_throwing_projectile() then return end

    local stop_running = not self._equipped_unit:base():run_and_shoot_allowed() and (not self.RUN_AND_RELOAD or not self:_is_reloading())
    if stop_running then self._ext_camera:play_redirect(self:get_animation("stop_running"), speed_multiplier) end
  end
end)

Hooks:OverrideFunction(PlayerStandard, "_interupt_action_running", function(self, t)
  if self:_changing_weapon() then return end
  if self._running and not self._end_running_expire_t then self:_end_action_running(t) end
end)

-- Increased gravity (981 to 1800)
Hooks:PostHook(PlayerStandard, "_enter", "CrimDawn_PlayerStandardEnter", function(self)
  if self._state_data.on_ladder then self._unit:mover():set_gravity(Vector3(0, 0, 0))
  else self._unit:mover():set_gravity(Vector3(0, 0, -1800)) end

  -- Go loud if we somehow haven't triggered it yet
  if managers.groupai:state():is_police_called() then return end

  if NetworkHelper:IsHost() then CrimDusk.GoLoud() return end
  NetworkHelper:SendToPeer(1, "CrimDusk_MaskedUp", true)
end)

Hooks:OverrideFunction(PlayerStandard, "_activate_mover", function(self, mover, velocity)
  self._unit:activate_mover(mover, velocity)

  if self._state_data.on_ladder then self._unit:mover():set_gravity(Vector3(0, 0, 0))
  else self._unit:mover():set_gravity(Vector3(0, 0, -1800)) end

  if self._is_jumping then
    self._unit:mover():jump()
    self._unit:mover():set_velocity(velocity)
  end
end)

Hooks:OverrideFunction(PlayerStandard, "_end_action_ladder", function(self, t, input)
  if not self._state_data.on_ladder then return end
  self._state_data.on_ladder = false

  if self._unit:mover() then self._unit:mover():set_gravity(Vector3(0, 0, -1800)) end

  self._unit:movement():on_exit_ladder()
end)

Hooks:OverrideFunction(PlayerStandard, "_action_interact_forbidden", function(self)
  local action_forbidden = self:chk_action_forbidden("interact") or self._unit:base():stats_screen_visible() or
    self:_interacting() or self._ext_movement:has_carry_restriction() or self:is_deploying() or
    self._equipping_mask or self:_is_throwing_projectile() or self:_on_zipline()

  return action_forbidden
end)

-- Allow interacting while melee is out
Hooks:OverrideFunction(PlayerStandard, "_start_action_interact", function(self, t, input, timer, interact_object)
  self:_interupt_action_reload(t)
  self:_interupt_action_steelsight(t)
  self:_interupt_action_running(t)

  local final_timer = timer
  final_timer = managers.modifiers:modify_value("PlayerStandard:OnStartInteraction", final_timer, interact_object)
  self._interact_expire_t = final_timer

  local start_timer = 0

  self._interact_params = { object = interact_object, timer = final_timer, tweak_data = interact_object:interaction().tweak_data }

  if not self._state_data.melee_active then self:_play_unequip_animation()
  else self._change_weapon_data = { selection_wanted = (Utils:IsCurrentWeaponPrimary() and 2 or 1) }
    if not self:in_melee() then self:_start_action_melee(t, input) end -- hacky solution to fix anim bugs
    self:_interupt_action_melee(t)
    self:_play_unequip_animation()
  end

  managers.hud:show_interaction_bar(start_timer, final_timer)
  managers.network:session():send_to_peers_synched("sync_teammate_progress", 1, true, self._interact_params.tweak_data, final_timer, false)
  self._unit:network():send("sync_interaction_anim", true, self._interact_params.tweak_data)
end)

Hooks:OverrideFunction(PlayerStandard, "_interupt_action_interact", function(self, t, input, complete)
  if self._interact_expire_t then
    self:_clear_tap_to_interact()
    self._interact_expire_t = nil

    if alive(self._interact_params.object) then self._interact_params.object:interaction():interact_interupt(self._unit, complete) end

    self._ext_camera:camera_unit():base():remove_limits()
    self._interaction:interupt_action_interact(self._unit)
    managers.network:session():send_to_peers_synched("sync_teammate_progress", 1, false, self._interact_params.tweak_data, 0, complete and true or false)

    self._interact_params = nil

    if not self._state_data.melee_active then self:_play_equip_animation() end
    managers.hud:hide_interaction_bar(complete)
    self._unit:network():send("sync_interaction_anim", false, "")
  end
end)

-- Melee damage
Hooks:OverrideFunction(PlayerStandard, "_do_melee_damage", function(self, t, bayonet_melee, melee_hit_ray, melee_entry, hand_id)
  melee_entry = melee_entry or managers.blackmarket:equipped_melee_weapon()

  local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
  local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0

  local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)
  self._ext_camera:play_shaker(table.random(PlayerStandard._MELEE_VARS), math.max(0.3, charge_lerp_value))

  local sphere_cast_radius = 20
  local col_ray

  if melee_hit_ray then col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
  else col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius) end

  if col_ray and alive(col_ray.unit) then
    local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(charge_lerp_value)
    local damage_effect_mul = math.max(managers.player:upgrade_value("player", "melee_knockdown_mul", 1), managers.player:upgrade_value(self._equipped_unit:base():categories() and self._equipped_unit:base():categories()[1], "melee_knockdown_mul", 1))

    damage = damage * managers.player:get_melee_dmg_multiplier()
    damage_effect = damage_effect * damage_effect_mul
    col_ray.sphere_cast_radius = sphere_cast_radius

    local hit_unit = col_ray.unit

    if hit_unit:character_damage() then
      if bayonet_melee then self._unit:sound():play("fairbairn_hit_body", nil, false)
      else local hit_sfx = "hit_body"
        if hit_unit:character_damage() and hit_unit:character_damage().melee_hit_sfx then hit_sfx = hit_unit:character_damage():melee_hit_sfx() end
        self:_play_melee_sound(melee_entry, hit_sfx, self._melee_attack_var)
      end

      if not hit_unit:character_damage()._no_blood then
        managers.game_play_central:play_impact_flesh({ col_ray = col_ray })
        managers.game_play_central:play_impact_sound_and_effects({ no_decal = true, no_sound = true, col_ray = col_ray })
      end

      self._camera_unit:base():play_anim_melee_item("hit_body")

    else
      if self._on_melee_restart_drill and hit_unit:base() and (hit_unit:base().is_drill or hit_unit:base().is_saw) then
        hit_unit:base():on_melee_hit(managers.network:session():local_peer():id())
      end

      if bayonet_melee then self._unit:sound():play("knife_hit_gen", nil, false)
      else self:_play_melee_sound(melee_entry, "hit_gen", self._melee_attack_var) end

      self._camera_unit:base():play_anim_melee_item("hit_gen")
      managers.game_play_central:play_impact_sound_and_effects({ no_decal = true, no_sound = true, col_ray = col_ray, effect = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2") })
    end

    local custom_data
    if _G.IS_VR and hand_id then custom_data = { engine = hand_id == 1 and "right" or "left" } end

    managers.rumble:play("melee_hit", nil, nil, custom_data)
    managers.game_play_central:physics_push(col_ray)

    local character_unit, shield_knock
    local can_shield_knock = managers.player:has_category_upgrade("player", "shield_knock")
    if can_shield_knock and hit_unit:in_slot(8) and alive(hit_unit:parent()) and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
      shield_knock = true
      character_unit = hit_unit:parent()
    end

    character_unit = character_unit or hit_unit
    if character_unit:character_damage() and character_unit:character_damage().damage_melee then
      local dmg_multiplier = 1

      if not managers.enemy:is_civilian(character_unit) and not managers.groupai:state():is_enemy_special(character_unit) then
        dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "non_special_melee_multiplier", 1)
      else dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_damage_multiplier", 1) end

      dmg_multiplier = dmg_multiplier * managers.player:upgrade_value("player", "melee_" .. tostring(tweak_data.blackmarket.melee_weapons[melee_entry].stats.weapon_type) .. "_damage_multiplier", 1)

      if character_unit:base() and character_unit:base().char_tweak and character_unit:base():char_tweak().priority_shout then
        dmg_multiplier = dmg_multiplier * (tweak_data.blackmarket.melee_weapons[melee_entry].stats.special_damage_multiplier or 1)
      end

      if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
        self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
        self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or { nil, 0 }

        local stack = self._state_data.stacking_dmg_mul.melee
        if stack[1] and t < stack[1] then dmg_multiplier = 1 + (managers.player:upgrade_value("melee", "stacking_hit_damage_multiplier", 0) * stack[2]) * dmg_multiplier
        else stack[2] = 0 end
      end

      local health_ratio = self._ext_damage:health_ratio()
      local damage_health_ratio = managers.player:get_damage_health_ratio(health_ratio, "melee")

      if damage_health_ratio > 0 then dmg_multiplier = dmg_multiplier * (1 + self._damage_health_ratio_mul_melee * damage_health_ratio) end
      dmg_multiplier = dmg_multiplier * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)

      do
        local target_dead = character_unit:character_damage().dead and not character_unit:character_damage():dead()
        local target_hostile = managers.enemy:is_enemy(character_unit) and not tweak_data.character[character_unit:base()._tweak_table].is_escort and character_unit:brain():is_hostile()
        local life_leach_available = managers.player:has_category_upgrade("temporary", "melee_life_leech") and not managers.player:has_activate_temporary_upgrade("temporary", "melee_life_leech")

        if target_dead and target_hostile and life_leach_available then
          managers.player:activate_temporary_upgrade("temporary", "melee_life_leech")
          self._unit:character_damage():restore_health(managers.player:temporary_upgrade_value("temporary", "melee_life_leech", 1))
        end
      end

      local action_data = {}
      action_data.variant = "melee"
      if _G.IS_VR and melee_entry == "weapon" and not bayonet_melee then dmg_multiplier = 0.1 end
      action_data.damage = shield_knock and 0 or damage * dmg_multiplier
      action_data.damage_effect = damage_effect
      action_data.attacker_unit = self._unit
      action_data.col_ray = col_ray
      if shield_knock then action_data.shield_knock = can_shield_knock end

      action_data.name_id = melee_entry
      action_data.charge_lerp_value = charge_lerp_value

      if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
        self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
        self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or { nil, 0 }

        local stack = self._state_data.stacking_dmg_mul.melee
        if character_unit:character_damage().dead and not character_unit:character_damage():dead() then
          stack[1] = t + managers.player:upgrade_value("melee", "stacking_hit_expire_t", 5)
          stack[2] = math.min(stack[2] + 1, 9 / managers.player:upgrade_value("melee", "stacking_hit_damage_multiplier", 0.1))
        else
          stack[1] = nil
          stack[2] = 0
        end
      end

      local defense_data = character_unit:character_damage():damage_melee(action_data)
      self:_check_melee_special_damage(col_ray, character_unit, defense_data, melee_entry)
      self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)
      return defense_data
    else self:_perform_sync_melee_damage(hit_unit, col_ray, damage) end
  end

  if managers.player:has_category_upgrade("melee", "stacking_hit_damage_multiplier") then
    self._state_data.stacking_dmg_mul = self._state_data.stacking_dmg_mul or {}
    self._state_data.stacking_dmg_mul.melee = self._state_data.stacking_dmg_mul.melee or { nil, 0 }

    local stack = self._state_data.stacking_dmg_mul.melee
    stack[1] = nil
    stack[2] = 0
  end

  return col_ray
end)