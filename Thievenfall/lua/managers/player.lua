local FileIdent = "PlayerManager"

PlayerManager._SHOCK_AND_AWE_TARGET_KILLS = 3

Hooks:OverrideFunction(PlayerManager, "verify_equipment", function() return true end)
Hooks:OverrideFunction(PlayerManager, "health_skill_multiplier", function() return 1 end)
Hooks:OverrideFunction(PlayerManager, "carry_blocked_by_cooldown", function() return false end)
Hooks:OverrideFunction(PlayerManager, "health_regen", function() return 0 end)
Hooks:OverrideFunction(PlayerManager, "add_cable_ties", function() end)

Hooks:OverrideFunction(PlayerManager, "fixed_health_regen", function(self)
  local health_regen = 0

  if not health_ratio or not self:is_damage_health_ratio_active(health_ratio) then
    health_regen = health_regen + self:upgrade_value("team", "crew_health_regen", 0)
    health_regen = health_regen + self:get_hostage_bonus_addend("health_regen")
    health_regen = health_regen + self:upgrade_value("player", "passive_health_regen", 0)
  end

  return health_regen
end)

Hooks:PreHook(PlayerManager, "on_enter_custody", "CrimDusk_PlayerOnEnterCustody", function(self, player, _, heist_start)
  if player == self:player_unit() then
    local lives = NetworkHelper:IsClient() and "lives" or "lives" .. CrimDusk.IsPermadeath()
    Global.CrimDusk.data[lives] = -1
    CrimDusk.Log(FileIdent, "Taken into custody!", true)
  end
end)

Hooks:OverrideFunction(PlayerManager, "body_armor_value", function(self, category, override_value, default)
  local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor()]
  return self:upgrade_value_by_level("player", "body_armor", category, {})[override_value or armor_data.upgrade_level] or default or 0
end)

Hooks:OverrideFunction(PlayerManager, "_dodge_replenish_armor", function(self)
  self:player_unit():character_damage():restore_health(0.1, true)
end)

Hooks:OverrideFunction(PlayerManager, "health_skill_addend", function(self)
  local addend = 0
  addend = addend + self:upgrade_value("team", "crew_add_health", 0)
  addend = addend - self:upgrade_value("player", "health_decrease", 0)

  -- Convert health multipliers to flat amount
  addend = addend + self:upgrade_value("player", "health_multiplier", 0)
  addend = addend + self:upgrade_value("player", "passive_health_multiplier", 0)
  addend = addend + self:upgrade_value("health", "passive_multiplier", 0)
  addend = addend + self:get_hostage_bonus_multiplier("health") - 1
  addend = addend + self:upgrade_value("player", "mrwi_health_multiplier", 0)

  if self:num_local_minions() > 0 then
    addend = addend + self:upgrade_value("player", "minion_master_health_multiplier", 0)
  end

  -- Max health can't go below 1
  if PlayerDamage._HEALTH_INIT + addend <= 0 then addend = -PlayerDamage._HEALTH_INIT + 0.1 end
  return addend
end)

Hooks:OverrideFunction(PlayerManager, "body_armor_skill_addend", function(self, override_armor)
  local addend = 0
  addend = addend + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_armor_addend", 0)

  if self:has_category_upgrade("player", "armor_increase") then
    local AnarchArmour = self:upgrade_value("player", "armor_increase", 1)
    addend = addend + AnarchArmour
  end

  addend = addend + self:upgrade_value("team", "crew_add_armor", 0)
  return addend
end)

-- Aggressive Reload triggers on any single shot weapon
Hooks:OverrideFunction(PlayerManager, "_on_activate_aggressive_reload_event", function(self, attack_data)
  if attack_data then local weapon_unit = self:equipped_weapon_unit()
    if weapon_unit then
      local weapon = weapon_unit:base()
      if weapon and weapon:fire_mode() == "single" then self:activate_temporary_upgrade("temporary", "single_shot_fast_reload") end
    end
  end
end)

-- Ammo Efficiency triggers on any single shot weapon
Hooks:OverrideFunction(PlayerManager, "_on_enter_ammo_efficiency_event", function(self)
  if not self._coroutine_mgr:is_running("ammo_efficiency") then
    local weapon_unit = self:equipped_weapon_unit()
    if weapon_unit and weapon_unit:base():fire_mode() == "single" then
      self._coroutine_mgr:add_coroutine("ammo_efficiency", PlayerAction.AmmoEfficiency, self, self._ammo_efficiency.headshots, self._ammo_efficiency.ammo, Application:time() + self._ammo_efficiency.time)
    end
  end
end)

-- Lock n' Load triggers on any full auto weapon
Hooks:OverrideFunction(PlayerManager, "_on_enter_shock_and_awe_event", function(self)
  if not self._coroutine_mgr:is_running("automatic_faster_reload") then
    local equipped_unit = self:get_current_state()._equipped_unit
    local data = self:upgrade_value("player", "automatic_faster_reload", nil)

    if data and equipped_unit and (equipped_unit:base():fire_mode() == "auto" or equipped_unit:base():fire_mode() == "burst") then
      self._coroutine_mgr:add_and_run_coroutine("automatic_faster_reload", PlayerAction.ShockAndAwe, self, data.target_enemies, data.max_reload_increase, data.min_reload_increase, data.penalty, data.min_bullets, equipped_unit)
    end
  end
end)

Hooks:PostHook(PlayerManager, "on_killshot", "CrimDusk_TrackWeaponKill", function(self, killed_unit, variant, headshot, weapon_id)
  if CopDamage.is_civilian(killed_unit:base()._tweak_table) then return end
  Global.CrimDawn.weapon_levels[weapon_id] = (Global.CrimDawn.weapon_levels[weapon_id] or 0) + 1
end)