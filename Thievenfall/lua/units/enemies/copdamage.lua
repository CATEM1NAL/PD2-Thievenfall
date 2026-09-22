local FileIdent = "CopDamage"

if NetworkHelper:IsHost() then -- Special characters stay dead for rest of campaign
  Hooks:PreHook(CopDamage, "die", "CrimDusk_PreCopDie", function(self)
    local enemy = self._unit:base()._tweak_table

    if enemy == "phalanx_vip" then
      Global.CrimDusk.data["winters_dead" .. CrimDusk.IsPermadeath()] = true
      CrimDusk:WriteSave(FileIdent, "Winters killed")

    elseif enemy == "hector_boss" or enemy == "hector_boss_no_armor" then
      Global.CrimDusk.data["hector_dead" .. CrimDusk.IsPermadeath()] = true
      CrimDusk:WriteSave(FileIdent, "Hector killed")
    end
  end)
end

Hooks:OverrideFunction(CopDamage, "damage_tase", function(self, attack_data)
  if self._dead or self._invulnerable then return end
  if PlayerDamage.is_friendly_fire(self, attack_data.attacker_unit) then return "friendly_fire" end
  if self:chk_immune_to_attacker(attack_data.attacker_unit) then return end

  local result
  local damage = attack_data.damage

  if attack_data.attacker_unit == managers.player:player_unit() then
    local critical_hit, crit_damage = self:roll_critical_hit(attack_data, damage)
    if critical_hit then damage = crit_damage end

    if attack_data.weapon_unit then
      if critical_hit then managers.hud:on_crit_confirmed()
      else managers.hud:on_hit_confirmed() end
    end
  end

  damage = self:_apply_damage_reduction(damage)
  damage = math.clamp(damage, 0, self._HEALTH_INIT)

  local damage_percent = math.ceil(damage / self._HEALTH_INIT_PRECENT)

  damage = damage_percent * self._HEALTH_INIT_PRECENT
  damage, damage_percent = self:_apply_min_health_limit(damage, damage_percent)

  if self._unit:base()._tweak_table == "taser" then damage = self._HEALTH_INIT end

  if damage >= self._health then
    attack_data.damage = self._health
    result = { type = "death", variant = "bullet" }
    self:die(attack_data)
    self:chk_killshot(attack_data.attacker_unit, "tase", false, attack_data.weapon_unit and attack_data.weapon_unit:base():get_name_id())

  else
    attack_data.damage = damage
    local type = (attack_data.forced or self._char_tweak.can_be_tased == nil or self._char_tweak.can_be_tased) and "taser_tased" or "none"
    result = { type = type, variant = attack_data.variant }
    self:_apply_damage_to_health(damage)
  end

  if result.type == "taser_tased" and (attack_data.forced or not self._unit:anim_data() or not self._unit:anim_data().act) then
    self.is_tased = true
    if self._tase_effect then World:effect_manager():fade_kill(self._tase_effect) end
    self._tase_effect = World:effect_manager():spawn(self._tase_effect_table)
  end

  attack_data.result = result
  attack_data.pos = attack_data.col_ray.position

  local head
  if result.type == "death" and self._head_body_name then
    head = attack_data.col_ray and attack_data.col_ray.body and self._head_body_key and attack_data.col_ray.body:key() == self._head_body_key

    local body = self._unit:body(self._head_body_name)
    local dir_vec = head and attack_data.col_ray.ray or body:rotation():y()

    self:_spawn_head_gadget({
      position = body:position(),
      rotation = body:rotation(),
      skip_push = not head,
      dir = dir_vec
    })
  end

  local attacker = attack_data.attacker_unit
  if not attacker or attacker:id() == -1 then attacker = self._unit end

  if result.type == "death" then
    local data = {
      name = self._unit:base()._tweak_table,
      stats_name = self._unit:base()._stats_name,
      owner = attack_data.owner,
      weapon_unit = attack_data.weapon_unit,
      variant = attack_data.variant,
      head_shot = head
    }

    managers.statistics:killed_by_anyone(data)
    local attacker_unit = attack_data.attacker_unit

    if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
      attacker_unit = attacker_unit:base():thrower_unit()
      data.weapon_unit = attack_data.attacker_unit
    end

    if attacker_unit == managers.player:player_unit() then
      if alive(attacker_unit) then self:_comment_death(attacker_unit, self._unit) end

      self:_show_death_hint(self._unit:base()._tweak_table)
      managers.statistics:killed(data)

      if CopDamage.is_civilian(self._unit:base()._tweak_table) then managers.money:civilian_killed() end

      self:_check_damage_achievements(attack_data, false)
    end
  end

  local weapon_unit = attack_data.weapon_unit

  if alive(weapon_unit) and weapon_unit:base() and weapon_unit:base().add_damage_result then
    weapon_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
  end

  local variant = result.variant == "heavy" and 1 or 0

  self:_send_tase_attack_result(attack_data, damage_percent, variant)
  self:_on_damage_received(attack_data)

  return result
end)

Hooks:OverrideFunction(CopDamage, "stun_hit", function(self, attack_data)
  if self._dead or self._invulnerable then return end
  if self:is_friendly_fire(attack_data.attacker_unit) then return "friendly_fire" end
  if self:chk_immune_to_attacker(attack_data.attacker_unit) then return end

  local damage
  if self._unit:base()._tweak_table == "spooc" then damage = true end

  local result = { type = "concussion", variant = attack_data.variant }
  if damage then
    attack_data.damage = self._health
    result.type = "death"
    self:die(attack_data)
    self:chk_killshot(attack_data.attacker_unit, "stun", false, attack_data.weapon_unit and attack_data.weapon_unit:base():get_name_id())
  end

  attack_data.result = result
  attack_data.pos = attack_data.col_ray.position

  local damage_percent = attack_data.damage or 0
  local attacker = attack_data.attacker_unit

  self:_send_stun_attack_result(attacker, damage_percent, self:_get_attack_variant_index(attack_data.result.variant), attack_data.col_ray.ray)
  self:_on_damage_received(attack_data)
  self:_create_stun_exit_clbk()
end)

Hooks:OverrideFunction(CopDamage, "_dismember_condition", function(self, attack_data)
  local dismember_victim = false
  local target_is_spook = false

  if alive(attack_data.col_ray.unit) and attack_data.col_ray.unit:base() then
    target_is_spook = attack_data.col_ray.unit:base()._tweak_table == "spooc"
  end

  local ValidMelee = tweak_data.blackmarket.melee_weapons[managers.blackmarket:equipped_melee_weapon()].dismember
  if target_is_spook and ValidMelee then dismember_victim = true end
  return dismember_victim
end)

Hooks:OverrideFunction(CopDamage, "_sync_dismember", function(self, attacker_unit)
  local dismember_victim = false
  if not attacker_unit then return dismember_victim end

  local peer_id = managers.network:session():peer_by_unit(attacker_unit):id()
  local peer = managers.network:session():peer(peer_id)
  local ValidMelee = tweak_data.blackmarket.melee_weapons[peer:melee_id()].dismember

  if ValidMelee then dismember_victim = true end
  return dismember_victim
end)

Hooks:OverrideFunction(CopDamage, "_check_special_death_conditions", function(self, variant, body, _, weapon_unit)
  local special_deaths = self._unit:base():char_tweak().special_deaths
  if not special_deaths or not special_deaths[variant] then return end

  local body_data = special_deaths[variant][body:name():key()]
  if not body_data then return end

  if alive(weapon_unit) then
    local factory_id = weapon_unit:base()._factory_id
    if not factory_id then return end

    if weapon_unit:base():is_npc() then factory_id = utf8.sub(factory_id, 1, -5) end

    local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(factory_id)
    local DmgMult = tweak_data.weapon[weapon_id].stats_modifiers and tweak_data.weapon[weapon_id].stats_modifiers.damage or 1
    if 100 <= (tweak_data.weapon[weapon_id].stats.damage * DmgMult) then
      if self._unit:damage():has_sequence(body_data.sequence) then self._unit:damage():run_sequence_simple(body_data.sequence) end
      if body_data.special_comment then return body_data.special_comment end
    end
  end
end)