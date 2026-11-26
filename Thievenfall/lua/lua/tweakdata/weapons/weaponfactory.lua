Hooks:OverrideFunction(WeaponFactoryTweakData, "create_bonuses", function() end)

Hooks:PostHook(WeaponFactoryTweakData, "init", "CrimDusk_InitModTweakData", function(self)
  for _, data in pairs(self.parts) do data.is_a_unlockable = true end -- All weapon mods are infinite

  -- Apply weapon part stat changes
  for Part, StatTable in pairs(Global.CrimDusk.weapon_parts.stats) do
    local OriginalZoom = self.parts[Part].stats.zoom
    local GadgetZoom = self.parts[Part].stats.gadget_zoom
    self.parts[Part].stats = StatTable
    self.parts[Part].stats.spread_moving = StatTable.spread
    if not StatTable.zoom then self.parts[Part].stats.zoom = OriginalZoom end
    if not StatTable.gadget_zoom then self.parts[Part].stats.gadget_zoom = GadgetZoom end
  end

  for Part, StatTable in pairs(Global.CrimDusk.weapon_parts.custom_stats) do self.parts[Part].custom_stats = StatTable end

  -- Magazine capacities
  for magazine, data in pairs(Global.CrimDusk.weapon_parts.mags) do
    if not self.parts[magazine].stats then self.parts[magazine].stats = {} end
    if data.extra_ammo then self.parts[magazine].stats.extra_ammo = data.extra_ammo end
    if data.reload then self.parts[magazine].stats.reload = data.reload end
  end

  -- Overrides
  self.wpn_fps_sho_x_basset.override.wpn_fps_sho_basset_m_extended.stats.extra_ammo = 10 -- Grimm/Izhma extended mag

  -- AK74 DMR kit
  self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.stats.damage = 50
  self.wpn_fps_ass_74.override.wpn_fps_upg_ass_ak_b_zastava.custom_stats = { fire_rate_multiplier = 0.8, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.5 }

  -- M16 DMR kit
  self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.damage = 51
  self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.stats.total_ammo_mod = -8
  self.wpn_fps_ass_m16.override.wpn_fps_upg_ass_m4_b_beowulf.custom_stats = { fire_rate_multiplier = 0.667, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.5 }

  -- Sting grenades
  local HighDamage = -133
  local LowDamage = -126
  local StingDamage = {
    wpn_fps_gre_m79 = HighDamage, wpn_fps_gre_slap = HighDamage, wpn_fps_ass_contraband = HighDamage, wpn_fps_ass_groza = HighDamage,
    wpn_fps_gre_m32 = LowDamage, wpn_fps_gre_china = LowDamage, wpn_fps_gre_arbiter = LowDamage, wpn_fps_gre_ms3gl = LowDamage
  }

  self.parts.wpn_fps_upg_a_grenade_launcher_hornet.custom_stats.rays = 18
  for weapon, damage in pairs(StingDamage) do
    if self[weapon].override.wpn_fps_upg_a_grenade_launcher_hornet then
      self[weapon].override.wpn_fps_upg_a_grenade_launcher_hornet.stats.damage = damage

    elseif self[weapon].override.wpn_fps_upg_a_underbarrel_hornet then
      self[weapon].override.wpn_fps_upg_a_underbarrel_hornet.custom_stats.damage = damage
    end
  end

  -- Shotgun ammo types
  self.parts.wpn_fps_upg_a_custom_free.custom_stats.rays = 6 -- 000 Buckshot

  -- Slugs
  self.parts.wpn_fps_upg_a_slug.stats.damage = 80
  self.parts.wpn_fps_upg_a_slug.stats.spread = 8
  self.parts.wpn_fps_upg_a_slug.stats.spread_moving = self.parts.wpn_fps_upg_a_slug.stats.spread * 0.5

  -- HE
  self.parts.wpn_fps_upg_a_explosive.stats.damage = 50

  -- Dragon's Breath
  self.parts.wpn_fps_upg_a_dragons_breath.stats.damage = -15
  self.parts.wpn_fps_upg_a_dragons_breath.stats.spread = -3

  -- Tombstone
  self.parts.wpn_fps_upg_a_rip.custom_stats.rays = 1
  self.parts.wpn_fps_upg_a_rip.stats.damage = 30
  self.parts.wpn_fps_upg_a_rip.stats.spread = 6
  self.parts.wpn_fps_upg_a_rip.stats.spread_moving = self.parts.wpn_fps_upg_a_rip.stats.spread * 0.5

  -- Flechette
  self.parts.wpn_fps_upg_a_piercing.custom_stats.rays = 12
  self.parts.wpn_fps_upg_a_piercing.stats.damage = -5
  self.parts.wpn_fps_upg_a_piercing.stats.spread = 4
  self.parts.wpn_fps_upg_a_piercing.stats.spread_moving = self.parts.wpn_fps_upg_a_piercing.stats.spread * 0.5

  -- Remove DLC buckshot
  local shotguns = { "wpn_fps_shot_saiga", "wpn_fps_shot_r870", "wpn_fps_shot_huntsman", "wpn_fps_shot_serbu", "wpn_fps_sho_ben", "wpn_fps_sho_striker",
    "wpn_fps_sho_ksg", "wpn_fps_pis_judge", "wpn_fps_sho_spas12", "wpn_fps_shot_b682", "wpn_fps_sho_aa12", "wpn_fps_sho_boot", "wpn_fps_shot_m37",
    "wpn_fps_shot_m1897", "wpn_fps_sho_m590", "wpn_fps_sho_rota", "wpn_fps_sho_basset", "wpn_fps_sho_x_basset", "wpn_fps_pis_x_judge", "wpn_fps_sho_x_rota",
    "wpn_fps_sho_coach", "wpn_fps_sho_ultima", "wpn_fps_sho_sko12", "wpn_fps_sho_x_sko12", "wpn_fps_sho_supernova", "wpn_fps_sho_bleckert" }
  for _, weapon in ipairs(shotguns) do
    for index, ammo in ipairs(self[weapon].uses_parts) do
      if ammo == "wpn_fps_upg_a_custom" then table.remove(self[weapon].uses_parts, index) break end
    end
  end

  -- Bayonet buff
  self.parts.wpn_fps_snp_mosin_ns_bayonet.stats = {
    concealment = -2, weapon_type = "sharp",
    min_damage = 5, max_damage = 5,
    min_damage_effect = 0.5, max_damage_effect = 0.5,
    value = 1
  }

  --[[ for index, mod in ipairs(self.wpn_fps_ass_contraband.default_blueprint) do
    if mod == "wpn_fps_ass_contraband_gl_m203" then table.remove(self.wpn_fps_ass_contraband.default_blueprint, index) break end
  end ]]
end)