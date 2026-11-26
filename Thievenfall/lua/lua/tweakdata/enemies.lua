local function SetStats(self, diff)
  local flashbang_mult = { 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2 }
  local weapon_preset = { "normal", "normal", "good", "good", "expert", "expert", "deathwish" }
  local cloaker_cooldown = {
    { 10, 10 }, { 8, 10 }, { 6, 8 }, { 4, 6 }, { 3, 4 }, { 2, 3 }, { 1, 2 }
  }

  -- ZEAL snipers are snipers
  self.heavy_swat_sniper.surrender = nil
  self.heavy_swat_sniper.tags = { "law", "marksman", "special" }
  self.heavy_swat_sniper.priority_shout = "f34"

  -- Crew AI
  self.presets.gang_member_damage.REGENERATE_TIME = 2
  self.presets.gang_member_damage.REGENERATE_TIME_AWAY = 0.6
  self.presets.gang_member_damage.HEALTH_INIT = 100
  self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = self.presets.gang_member_damage.HEALTH_INIT * 0.1

  -- Medics can't heal specials
  self.heavy_swat_sniper.can_be_healed = false
  self.tank.can_be_healed = false
  self.tank_mini.can_be_healed = false
  self.shield.can_be_healed = false
  self.phalanx_minion.can_be_healed = false
  self.taser.can_be_healed = false
  self.sniper.can_be_healed = false
  self.marshal_marksman.can_be_healed = false
  self.marshal_shield.can_be_healed = false
  self.marshal_shield_break.can_be_healed = false

  -- Enemy HP
  local WeakEnemies = {
    "security", "security_undominatable", "mute_security_undominatable", "security_mex", "security_mex_no_pager", "sniper",
    "fbi", "fbi_female", "gensec", "cop", "cop_scared", "cop_female", "gangster", "biker", "biker_female", "triad", "biker_escape",
    "captain", "captain_female", "biker_escape", "mobster", "hector_boss_no_armor", "bolivian_indoors_mex", "bolivian", "ranchmanager",
    "drug_lord_boss_stealth", "triad_boss_no_armor", "shadow_spooc"
  }
  local LightEnemies = { "swat", "zeal_swat", "fbi_swat", "city_swat", "marshal_marksman", "shield" }
  local HeavyEnemies = { "medic", "taser", "heavy_swat", "zeal_heavy_swat", "heavy_swat_sniper", "fbi_heavy_swat", "marshal_shield", "marshal_shield_break" }
  local ResistantEnemies = { "phalanx_minion", "spooc" }
  local MiniBosses = { "hector_boss", "mobster_boss", "biker_boss", "drug_lord_boss", "triad_boss", "chavez_boss" }
  local Bosses = { "phalanx_vip", "tank", "tank_medic", "tank_mini", "deep_boss" }

  for _, enemy in ipairs(WeakEnemies) do self[enemy].HEALTH_INIT = 5 end
  for _, enemy in ipairs(LightEnemies) do self[enemy].HEALTH_INIT = 10 end
  for _, enemy in ipairs(HeavyEnemies) do self[enemy].HEALTH_INIT = 20 end
  for _, enemy in ipairs(ResistantEnemies) do self[enemy].HEALTH_INIT = 30 end
  for _, enemy in ipairs(MiniBosses) do self[enemy].HEALTH_INIT = 100 end
  for _, enemy in ipairs(Bosses) do self[enemy].HEALTH_INIT = 300 end

  -- Boss damage clamps
  self.hector_boss.DAMAGE_CLAMP_BULLET = nil
  self.hector_boss.DAMAGE_CLAMP_EXPLOSION = nil

  self.biker_boss.DAMAGE_CLAMP_BULLET = nil
  self.biker_boss.DAMAGE_CLAMP_EXPLOSION = nil

  self.chavez_boss.DAMAGE_CLAMP_BULLET = nil
  self.chavez_boss.DAMAGE_CLAMP_EXPLOSION = nil

  self.drug_lord_boss.DAMAGE_CLAMP_BULLET = nil
  self.drug_lord_boss.DAMAGE_CLAMP_EXPLOSION = nil
  self.drug_lord_boss_stealth.DAMAGE_CLAMP_BULLET = nil
  self.drug_lord_boss_stealth.DAMAGE_CLAMP_EXPLOSION = nil

  self.phalanx_vip.FINAL_LOWER_HEALTH_PERCENTAGE_LIMIT = nil
  self.phalanx_vip.DAMAGE_CLAMP_BULLET = 10
  self.phalanx_vip.DAMAGE_CLAMP_EXPLOSION = self.phalanx_vip.DAMAGE_CLAMP_BULLET

  -- Winters shield
  self.phalanx_minion.headshot_dmg_mul = 2
  self.phalanx_minion.damage.explosion_damage_mul = 0.8
  self.phalanx_minion.damage.shield_knocked = true
  self.phalanx_minion.damage.immune_to_knockback = nil
  self.phalanx_minion.immune_to_knock_down = nil
  self.phalanx_minion.immune_to_concussion = nil
  self.phalanx_minion.DAMAGE_CLAMP_BULLET = nil
  self.phalanx_minion.DAMAGE_CLAMP_EXPLOSION = nil

  -- Marshall shield
  self.marshal_shield.damage.shield_knocked = true
  self.marshal_shield.damage.immune_to_knockback = nil
  self.marshal_shield.immune_to_knock_down = nil
  self.marshal_shield.immune_to_concussion = nil
  self.marshal_shield_break.modify_health_on_tweak_change = nil
  self.marshal_shield_break.tmp_invulnerable_on_tweak_change = nil

  -- Dozers
  self.tank.headshot_dmg_mul = 15
  self.tank_medic.headshot_dmg_mul = self.tank.headshot_dmg_mul
  self.tank_mini.headshot_dmg_mul = self.tank.headshot_dmg_mul

  -- Cloakers
  self.spooc.headshot_dmg_mul = 6
  self.spooc.spooc_attack_timeout = cloaker_cooldown[diff]
  self.spooc.spooc_attack_beating_time[1] = cloaker_cooldown[diff][1]
  self.spooc.spooc_attack_beating_time[2] = cloaker_cooldown[diff][1]

  -- Fix melee damage being absurd
  local EnemyMeleeDamage = 10
  for _, weapon_data in pairs(self.presets.weapon.expert) do
    if weapon_data.melee_dmg and weapon_data.FALLOFF then
      weapon_data.melee_dmg = EnemyMeleeDamage
    end
  end

  -- Damage curves (based on vanilla OVK/Mayhem)
  local expert = self.presets.weapon.expert
  local skip = { expert = true, gang_member = true, sniper = true, bot_weapons = true }

  for preset, preset_data in pairs(self.presets.weapon) do

    if not skip[preset] then
      -- Enemy damage steps
      for weapon_name, weapon_data in pairs(preset_data) do
        if weapon_data.FALLOFF and expert[weapon_name].FALLOFF then
          weapon_data.FALLOFF = expert[weapon_name].FALLOFF
        end

        if weapon_data.melee_dmg and weapon_data.FALLOFF then weapon_data.melee_dmg = EnemyMeleeDamage end
      end

    elseif preset == "gang_member" then
      -- Remove crew AI damage multipliers, add fall-off
      for weapon_name, weapon_data in pairs(preset_data) do
        if weapon_data.FALLOFF then
          for index, DistanceData in ipairs(weapon_data.FALLOFF) do
            if DistanceData.dmg_mul then DistanceData.dmg_mul = math.max(1 - (index - 1 * 0.2), 0.01) end
          end
        end
      end

    end
  end

  self:_set_characters_weapon_preset(weapon_preset[diff])
  self:_multiply_weapon_delay(self.presets.weapon.sniper, 3)
  self.marshal_marksman.weapon.is_rifle.focus_delay = 3

  self.hector_boss.weapon.is_shotgun_mag.FALLOFF = {
    { dmg_mul = 2.2, r = 200, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 0, 1, 2, 1 } },
    { dmg_mul = 1.75, r = 500, acc = { 0.6, 0.9 }, recoil = { 0.4, 0.7 }, mode = { 0, 3, 3, 1 } },
    { dmg_mul = 1.5, r = 1000, acc = { 0.4, 0.8 }, recoil = { 0.45, 0.8 }, mode = { 1, 2, 2, 0 } },
    { dmg_mul = 1.25, r = 2000, acc = { 0.4, 0.55 }, recoil = { 0.45, 0.8 }, mode = { 3, 2, 2, 0 } },
    { dmg_mul = 1, r = 3000, acc = { 0.1, 0.35 }, recoil = { 1, 1.2 }, mode = { 3, 1, 1, 0 } }
  }

  if diff > 4 then self.sniper.weapon.is_rifle.use_laser = false end
  self.sniper.weapon.is_rifle.FALLOFF = {
    { dmg_mul = 10, r = 700, acc = { 0.7, 1 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 10, r = 4000, acc = { 0.6, 0.95 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } },
    { dmg_mul = 6, r = 10000, acc = { 0.2, 0.5 }, recoil = { 3, 5 }, mode = { 1, 0, 0, 0 } }
  }

  -- Finalization
  local CanCuff = {
    fbi = true, fbi_female = true,
    medic = true, sniper = true, marshal_marksman = true, taser = true, 
    swat = true, heavy_swat = true,
    zeal_swat = true, zeal_heavy_swat = true, heavy_swat_sniper = true,
    fbi_swat = true, fbi_heavy_swat = true
  }

  for _, npc in pairs(self) do
    if type(npc) == "table" then
      if npc.steal_loot and Global.game_settings.level_id ~= "chill_combat" then npc.steal_loot = nil end -- Enemies can't move bags
      if CanCuff[npc] then npc.no_arrest = nil end -- All enemies can cuff
    end
  end

  self.flashbang_multiplier = flashbang_mult[diff]
  self.concussion_multiplier = 1

  self:_process_weapon_usage_table()
end

Hooks:OverrideFunction(CharacterTweakData, "_set_normal", function(self) SetStats(self, 1) end) -- Normal
Hooks:OverrideFunction(CharacterTweakData, "_set_hard", function(self) SetStats(self, 2) end) -- Hard
Hooks:OverrideFunction(CharacterTweakData, "_set_overkill", function(self) SetStats(self, 3) end) -- V.Hard
Hooks:OverrideFunction(CharacterTweakData, "_set_overkill_145", function(self) SetStats(self, 4) end) -- OVK
Hooks:OverrideFunction(CharacterTweakData, "_set_easy_wish", function(self) SetStats(self, 5) end) -- Mayhem
Hooks:OverrideFunction(CharacterTweakData, "_set_overkill_290", function(self) SetStats(self, 6) end) -- DW
Hooks:OverrideFunction(CharacterTweakData, "_set_sm_wish", function(self) SetStats(self, 7) end) -- DS