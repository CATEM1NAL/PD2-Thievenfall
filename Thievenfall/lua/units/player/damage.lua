if Global.game_settings and Global.game_settings.level_id == "chill" then return end

local FileIdent = "PlayerDamage"

local lives
-- Safehouse Raid and Holdout shouldn't use campaign down time. Clients shouldn't use permadeath down time to avoid fucking their own campaigns.
if Global.game_settings and (Global.game_settings.level_id == "chill_combat" or tweak_data.levels[Global.game_settings.level_id].group_ai_state == "skirmish") then
  lives = "lives_oneoff"
  Global.CrimDusk.data[lives] = "max"
else lives = NetworkHelper:IsClient() and "lives" or "lives" .. CrimDusk.IsPermadeath() end

PlayerDamage._UPPERS_COOLDOWN = 1

-- Setup new values
Hooks:PreHook(PlayerDamage, "init", "CrimDusk_InitPlayerDamage", function(self)
  self._dodge_stack = 0
  self._entropy = 0
  self._entropy_mult = 0.1
  self._armor_broken = false
  self._armor_break_t = managers.player:player_timer():time() + 3
  self._max_lives = 31 + managers.player:upgrade_value("player", "additional_lives", 0)
  self._revive_health_range = tweak_data.player.damage.REVIVE_HEALTH_STEPS
  managers.environment_controller:set_last_life()
end)

-- Regen time varies with armour
Hooks:OverrideFunction(PlayerDamage, "set_regenerate_timer_to_max", function(self)
  local mul = managers.player:body_armor_regen_multiplier(alive(self._unit) and self._unit:movement():current_state()._moving, self:health_ratio())
  local armour = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()].upgrade_level
  self._regenerate_timer = Global.CrimDusk.regen_time[armour] * mul
  self._regenerate_timer = self._regenerate_timer * managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
  self._regenerate_speed = self._regenerate_speed or 1
  self._current_state = self._update_regenerate_timer
end)

-- Anarchist regen
Hooks:OverrideFunction(PlayerDamage, "_init_armor_grinding_data", function(self)
  local armor_grinding_data = managers.player:upgrade_value("player", "armor_grinding", nil)
  if armor_grinding_data and armor_grinding_data ~= 0 then
    local armour = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()].upgrade_level
    local suppression = 0
    if armour <= 4 then suppression = 0.5 end

    self._armor_grinding = {}
    self._armor_grinding.armor_value = self:_max_armor() * 0.5
    self._armor_grinding.target_tick = (Global.CrimDusk.regen_time[armour] + suppression) * 2
    self._armor_grinding.elapsed = 0
    return true
  end

  return false
end)

Hooks:OverrideFunction(PlayerDamage, "_update_armor_grinding", function(self, t, dt)
  self._armor_grinding.elapsed = self._armor_grinding.elapsed + dt
  if self._armor_grinding.elapsed >= self._armor_grinding.target_tick then
    self._armor_grinding.elapsed = 0
    self:change_armor(self._armor_grinding.armor_value)
    self:_send_set_armor()
  end
end)

-- Suppression changes
Hooks:OverrideFunction(PlayerDamage, "build_suppression", function(self, amount)
  local armour = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()].upgrade_level
  if armour > 4 then return end -- Flak/CTV/ICTV are unaffected

  amount = amount * managers.player:upgrade_value("player", "suppressed_multiplier", 1)
  amount = amount * tweak_data.player.suppression.receive_mul

  local data = self._supperssion_data
  data.value = math.min(tweak_data.player.suppression.max_value, (data.value or 0) + amount * tweak_data.player.suppression.receive_mul)
  data.decay_start_t = managers.player:player_timer():time() + tweak_data.player.suppression.decay_start_delay
end)

-- Regenerating armour resets armour break flag
Hooks:PostHook(PlayerDamage, "_regenerate_armor", "CrimDusk_PlayerRegenerateArmour", function(self)
  self._armor_broken = false
  self._regen_on_the_side = false
  self._regen_on_the_side_timer = 0
end)

-- Feign Death
Hooks:PostHook(PlayerDamage, "_chk_cheat_death", "CrimDusk_CheckFeignDeath", function(self)
  if self._auto_revive_timer then self._down_time = self._down_time - 10 end
end)

-- Stoic damage tick
Hooks:OverrideFunction(PlayerDamage, "delay_damage", function(self, damage, ticks)
  local damage_chunk = { tick = damage / ticks, remaining = damage }

  if not self._delayed_damage.next_tick then
    self._delayed_damage.next_tick = TimerManager:game():time() + 0.2
  end

  table.insert(self._delayed_damage.chunks, damage_chunk)
  managers.hud:set_teammate_delayed_damage(HUDManager.PLAYER_PANEL, self:remaining_delayed_damage())
end)

-- Stoic damage update
Hooks:OverrideFunction(PlayerDamage, "_update_delayed_damage", function(self, t, dt)
  local no_chunks = #self._delayed_damage.chunks == 0
  local time_for_tick = self._delayed_damage.next_tick and t < self._delayed_damage.next_tick
  if no_chunks or time_for_tick then return end

  self._delayed_damage.next_tick = t + 0.2

  local total_tick = 0
  local remaining_chunks = {}
  for _, damage_chunk in ipairs(self._delayed_damage.chunks) do
    total_tick = total_tick + damage_chunk.tick
    damage_chunk.remaining = damage_chunk.remaining - damage_chunk.tick

    if self._delayed_damage.epsilon < damage_chunk.remaining then
      table.insert(remaining_chunks, damage_chunk)
    end
  end

  self._delayed_damage.chunks = remaining_chunks

  if total_tick > 0 then
    self:damage_simple({ variant = "delayed_tick", damage = total_tick })
  end

  local remaining_damage = self:remaining_delayed_damage()
  if remaining_damage == 0 then self._delayed_damage.next_tick = nil end

  managers.hud:set_teammate_delayed_damage(HUDManager.PLAYER_PANEL, remaining_damage)
end)

-- Leech team healing
Hooks:OverrideFunction(PlayerDamage, "on_copr_heal_received", function(self)
  if self:get_real_health() < self:_max_health() then self:restore_health(0.1, true, true) end
end)

-- Leech kill immunity
Hooks:OverrideFunction(PlayerDamage, "on_copr_killshot", function(self)
  self._armor_break_t = managers.player:player_timer():time() + 1
end)

--[[ TODO; Leech rework
Plan is for Leech to grant immunity while active but also drain your health, with kills restoring health.
This would turn Leech into another aggressive perk deck which punishes activating randomly and rewards smart use.
All skills for the deck will also need reworking to fit around the new concept.
]]

-- Tooth & Claw regens after 3s, not 1.5s (vanilla timer is stupid).
Hooks:OverrideFunction(PlayerDamage, "_start_regen_on_the_side", function(self, time)
  if self._regen_on_the_side_timer <= 0 and time > 0 then
    self._regen_on_the_side_timer = 3
    self._regen_on_the_side = true
  end
end)

-- So I don't have to copy/paste this block repeatedly
function PlayerDamage:SetReviveRatio()
  local ReviveHealthRatio = self._down_time / 60
  self._revive_health_i = math.lerp(self._revive_health_range[2], self._revive_health_range[1], ReviveHealthRatio)
end

-- Gaining lives and health
Hooks:OverrideFunction(PlayerDamage, "_regenerated", function(self, no_messiah)
  if DelayedCalls._calls.CrimDusk_ForceIntoCustody then CrimDusk.Log(FileIdent, "ForceIntoCustody is running!", true) return end

  if not no_messiah then self._messiah_charges = managers.player:upgrade_value("player", "pistol_revive_from_bleed_out", 0) end

  -- Initial lives (start of heist)
  if Global.CrimDusk.data[lives] == "max" then -- Safehouse Raid & Holdout
    CrimDusk.Log(FileIdent, "Maxing out down time", true)
    Global.CrimDusk.data[lives] = self._max_lives - 1
    self._revives = Application:digest_value(Global.CrimDusk.data[lives] + 1, true)

  -- Regular heists
  elseif not self._down_time and Global.CrimDusk.data[lives] >= 0 and lives ~= "lives_oneoff" then
    CrimDusk.Log(FileIdent, "Setting initial down time", true)
    self._revives = Application:digest_value(math.min(Global.CrimDusk.data[lives] + 1, self._max_lives), true)

  elseif Global.CrimDusk.data[lives] == -2 then -- Custody carry over
    CrimDusk.Log(FileIdent, "Started in custody!", true)
    self:set_health(0)
    self._revives = Application:digest_value(1, true)
    DelayedCalls:Add("CrimDusk_ForceIntoCustody", 1, function() managers.player:on_enter_custody(managers.player:player_unit()) end)
  return

  -- Traded from custody
  elseif Global.CrimDusk.data[lives] == -1 then
    CrimDusk.Log(FileIdent, "Traded from custody", true)
    self._revives = Application:digest_value(11, true)
    Global.CrimDusk.data[lives] = 10

  -- Doctor bag
  else local NewDowns = Application:digest_value(self._revives, false) + 10
    CrimDusk.Log(FileIdent, "Used doctor bag", true)
    self._revives = Application:digest_value(math.min(NewDowns, self._max_lives), true)
  end

  -- Set down related values
  self._down_time = Application:digest_value(self._revives, false) - 1

  self:set_health(self:_max_health())
  self:_send_set_health()
  self:_set_health_effect()
  self:_send_set_revives()
  self._said_hurt = false

  self:SetReviveRatio()
end)

-- FAK healing
Hooks:OverrideFunction(PlayerDamage, "band_aid_health", function(self)
  if managers.platform:presence() == "Playing" and (self:arrested() or self:need_revive()) then return end
  self:change_health(self:_max_health() * self._healing_reduction)
  self._said_hurt = false

  -- TODO; Amphetamine skill should apply to the FAK itself, that way teammates benefit from the effect
  local DownTimeRecovery = managers.player:upgrade_value("first_aid_kit", "downs_restore_chance", 0)
  if DownTimeRecovery == 0 then return end

  local NewDowns = Application:digest_value(self._revives, false) + DownTimeRecovery
  CrimDusk.Log(FileIdent, "Used FAK", true)
  self._revives = Application:digest_value(math.min(NewDowns, self._max_lives), true)

  self._down_time = Application:digest_value(self._revives, false) - 1
  self:_send_set_revives()
  self:SetReviveRatio()
end)

-- On revive
Hooks:OverrideFunction(PlayerDamage, "revive", function(self, silent)
  if Application:digest_value(self._revives, false) == 0 then self._revive_health_multiplier = nil return end
  local arrested = self:arrested()

  managers.player:set_player_state("standard")
  managers.player:remove_copr_risen_cooldown()

  if not silent then PlayerStandard.say_line(self, "s05x_sin") end

  self._bleed_out = false
  self._incapacitated = nil

  local DownTime = math.ceil(self._downed_timer)
  self._downed_timer = nil
  self._downed_start_time = nil

  if not arrested then
    self:set_armor(self:_max_armor())

    if self:get_real_health() <= 0 then -- Being tased doesn't reset your health
      self:set_health(self:_max_health() * self._revive_health_i * (self._revive_health_multiplier or 1) * managers.player:upgrade_value("player", "revived_health_regain", 1))
      -- Revive health scales with down time remaining. More down time, more health.
    end

    -- Set down time related values
    self._down_time = DownTime
    self._revives = Application:digest_value(self._down_time + 1, true)
    self:_send_set_revives()
    Global.CrimDusk.data[lives] = self._down_time
    self:SetReviveRatio()

    self._revive_miss = self._dmg_interval -- Revive dodge matches grace period
  end

  self:_regenerate_armor()

  managers.hud:set_player_health({ current = self:get_real_health(), total = self:_max_health(), revives = Application:digest_value(self._revives, false) })
  self:_send_set_health()
  self:_set_health_effect()
  managers.hud:pd_stop_progress()

  self._revive_health_multiplier = nil

  self._listener_holder:call("on_revive")

  if managers.player:has_inactivate_temporary_upgrade("temporary", "revived_damage_resist") then
    managers.player:activate_temporary_upgrade("temporary", "revived_damage_resist")
  end

  if managers.player:has_inactivate_temporary_upgrade("temporary", "increased_movement_speed") then
    managers.player:activate_temporary_upgrade("temporary", "increased_movement_speed")
  end

  if managers.player:has_inactivate_temporary_upgrade("temporary", "swap_weapon_faster") then
    managers.player:activate_temporary_upgrade("temporary", "swap_weapon_faster")
  end

  if managers.player:has_inactivate_temporary_upgrade("temporary", "reload_weapon_faster") then
    managers.player:activate_temporary_upgrade("temporary", "reload_weapon_faster")
  end
end)

-- Grey screen effect scales with down time, not health
Hooks:OverrideFunction(PlayerDamage, "_set_health_effect", function(self)
  local ReviveHealthRatio = self._downed_timer and self._downed_timer / 30 or (self._down_time or Global.CrimDusk.data[lives]) / 30
  ReviveHealthRatio = math.min(ReviveHealthRatio, 1)
  managers.environment_controller:set_health_effect_value(ReviveHealthRatio)
end)

-- This bad boy can fit so many changes
Hooks:OverrideFunction(PlayerDamage, "damage_bullet", function(self, attack_data)
  if not self:_chk_can_take_dmg() then return end

  local damage_info = {
    result = { variant = "bullet", type = "hurt" },
    attacker_unit = attack_data.attacker_unit,
    attack_dir = attack_data.attacker_unit and attack_data.attacker_unit:movement():m_pos() - self._unit:movement():m_pos() or Vector3(1, 0, 0),
    pos = mvector3.copy(self._unit:movement():m_head_pos())
  }

  local pm = managers.player
  local dmg_mul = pm:damage_reduction_skill_multiplier("bullet")
  attack_data.damage = attack_data.damage * dmg_mul
  attack_data.damage = managers.mutators:modify_value("PlayerDamage:TakeDamageBullet", attack_data.damage)
  attack_data.damage = managers.modifiers:modify_value("PlayerDamage:TakeDamageBullet", attack_data.damage, attack_data.attacker_unit:base()._tweak_table)

  if _G.IS_VR then
    local distance = mvector3.distance(self._unit:position(), attack_data.attacker_unit:position())

    if tweak_data.vr.long_range_damage_reduction_distance[1] < distance then
      local step = math.clamp(distance / tweak_data.vr.long_range_damage_reduction_distance[2], 0, 1)
      local mul = 1 - math.step(tweak_data.vr.long_range_damage_reduction[1], tweak_data.vr.long_range_damage_reduction[2], step)
      attack_data.damage = attack_data.damage * mul
    end
  end

  -- Absorption (Maniac, Tag Team)
  local damage_absorption = pm:damage_absorption()
  if damage_absorption > 0 then attack_data.damage = attack_data.damage - damage_absorption end
  attack_data.damage = math.max(attack_data.damage, 0.1)

  self:copr_update_attack_data(attack_data)
  --log("Armour broken: " .. tostring(self._armor_broken) .. "\nImmunity expires at: " .. self._armor_break_t .. "\nCurrent time: " .. managers.player:player_timer():time())

  -- Sources of immunity
  if self._god_mode then
    if attack_data.damage > 0 then self:_send_damage_drama(attack_data, attack_data.damage) end
    self:_call_listeners(damage_info)
    return

  elseif self._invulnerable or self._mission_damage_blockers.invulnerable then self:_call_listeners(damage_info) return
  elseif self:incapacitated() then return
  elseif pm:player_timer():time() < self._armor_break_t then return
  elseif self._unit:movement():current_state().immortal then return
  elseif self._revive_miss and math.random() < self._revive_miss then self:play_whizby(attack_data.col_ray.position) return
  end

  -- Dodge
  local dodge_value = self._dodge_stack or 0
  local skill_dodge_chance = pm:skill_dodge_chance(self._unit:movement():running(), self._unit:movement():crouching(), self._unit:movement():zipline_unit())
  skill_dodge_chance = skill_dodge_chance + pm:body_armor_value("dodge")
  dodge_value = dodge_value + skill_dodge_chance - (skill_dodge_chance * self._entropy * self._entropy_mult)
  --[[
  log("current dodge: " .. dodge_value + skill_dodge_chance)
  log("entropy: " .. (skill_dodge_chance) * self._entropy * self._entropy_mult)
  log("final dodge: " .. dodge_value)
  ]]

  if self._temporary_dodge_t and TimerManager:game():time() < self._temporary_dodge_t then
    dodge_value = dodge_value + self._temporary_dodge
  end

  dodge_value = math.max(dodge_value, 0)

  local smoke_dodge = 0
  for _, smoke_screen in ipairs(managers.player._smoke_screen_effects or {}) do
    if smoke_screen:is_in_smoke(self._unit) then
      dodge_value = dodge_value + tweak_data.projectiles.smoke_screen_grenade.dodge_chance
    break end
  end

  if dodge_value >= 1 then
    --log(dodge_value .. " we dodged! Yippee!")
    self._dodge_stack = dodge_value - 1
    self._entropy = self._entropy + 1
    if attack_data.damage > 0 then self:_send_damage_drama(attack_data, 0) end

    self:_call_listeners(damage_info)
    self:play_whizby(attack_data.col_ray.position)
    self:_hit_direction(attack_data.attacker_unit:position(), attack_data.col_ray and attack_data.col_ray.ray or damage_info.attacK_dir)

    pm:send_message(Message.OnPlayerDodge, nil, attack_data)
  return end

  if self._dodge_stack ~= dodge_value then self._dodge_stack = dodge_value end
  self._entropy = 0
  --log(dodge_value .. " dodge failed :(")

  -- Taking damage
	if self:get_real_armor() > 0 then self._unit:sound():play("player_hit")
	else self._unit:sound():play("player_hit_permadamage") end

	local shake_armor_multiplier = pm:body_armor_value("damage_shake") * pm:upgrade_value("player", "damage_shake_multiplier", 1)
	local gui_shake_number = tweak_data.gui.armor_damage_shake_base / shake_armor_multiplier
	gui_shake_number = gui_shake_number + pm:upgrade_value("player", "damage_shake_addend", 0)
	shake_armor_multiplier = tweak_data.gui.armor_damage_shake_base / gui_shake_number
	local shake_multiplier = math.clamp(attack_data.damage, 0.2, 2) * shake_armor_multiplier

	self._unit:camera():play_shaker("player_bullet_damage", 1 * shake_multiplier)

	if not _G.IS_VR then managers.rumble:play("damage_bullet") end

	self:_hit_direction(attack_data.attacker_unit:position(), attack_data.col_ray and attack_data.col_ray.ray or damage_info.attacK_dir)
	pm:check_damage_carry(attack_data)

	attack_data.damage = pm:modify_value("damage_taken", attack_data.damage, attack_data)

	if self._bleed_out then self:_bleed_out_damage(attack_data) return end

	self:mutator_update_attack_data(attack_data)
	self:_check_chico_heal(attack_data)

	local armor_reduction_multiplier = 0
	if self:get_real_armor() <= 0 then armor_reduction_multiplier = 1 end

	local health_subtracted = self:_calc_armor_damage(attack_data)
	attack_data.damage = attack_data.damage * armor_reduction_multiplier
	health_subtracted = health_subtracted + self:_calc_health_damage(attack_data)

  if self:get_real_armor() <= 0 and not self._armor_broken then
    self._armor_break_t = pm:player_timer():time() + self._dmg_interval
    self._armor_broken = true
  end

	if not self._bleed_out and health_subtracted > 0 then self:_send_damage_drama(attack_data, health_subtracted)
	elseif self._bleed_out then self:chk_queue_taunt_line(attack_data) end

	pm:send_message(Message.OnPlayerDamage, nil, attack_data)
	self:_call_listeners(damage_info)
end)