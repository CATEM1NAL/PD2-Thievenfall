Hooks:OverrideFunction(WeaponFactoryTweakData, "create_bonuses", function() end)

Hooks:PostHook(WeaponFactoryTweakData, "init", "CrimDusk_InitModTweakData", function(self)
  for _, data in pairs(self.parts) do data.is_a_unlockable = true end -- All weapon mods are infinite

  -- Apply weapon part stat changes
  for Part, StatTable in pairs(Global.CrimDusk.weapon_parts) do
    local OriginalZoom = StatTable.increase_zoom and self.parts[Part].stats.zoom + 2 or self.parts[Part].stats.zoom
    local GadgetZoom = self.parts[Part].stats.gadget_zoom
    self.parts[Part].stats = StatTable
    if not StatTable.zoom then self.parts[Part].stats.zoom = OriginalZoom end
    if not StatTable.gadget_zoom then self.parts[Part].stats.gadget_zoom = GadgetZoom end
  end

  -- Magazine capacities
  local Quadstack = { MagChange = 30, ReloadSpeed = -2 }
  local LowCapacity = { MagChange = -10, ReloadSpeed = 10 }
  local QuickPull = { ReloadSpeed = 4 }

  local MagTweaks = {
    wpn_fps_sho_basset_m_extended = { MagChange = 5, ReloadSpeed = -4 },
    wpn_fps_sho_aa12_mag_drum = { MagChange = 12, ReloadSpeed = -4 },
    wpn_fps_m4_uupg_m_std = { MagChange = 10, ReloadSpeed = -1 },
  
    -- Quadstacks
    wpn_fps_upg_m4_m_quad = Quadstack,
    wpn_fps_upg_ak_m_quad = Quadstack,

    -- Speedpulls
    wpn_fps_smg_p90_m_strap = QuickPull,
    wpn_fps_ass_aug_m_quick = QuickPull,
    wpn_fps_m4_upg_m_quick = QuickPull,
    wpn_fps_upg_ak_m_quick = QuickPull,
    wpn_fps_ass_g36_m_quick = QuickPull,
    wpn_fps_smg_mac10_m_quick = QuickPull,
    wpn_fps_smg_sr2_m_quick = QuickPull,

    -- Small mags
    wpn_fps_upg_m4_m_straight = LowCapacity,
  }
  for magazine, data in pairs(MagTweaks) do
    for stat, value in pairs(data) do
      if stat == "MagChange" then self.parts[magazine].stats.extra_ammo = value end
      if stat == "ReloadSpeed" then self.parts[magazine].stats.reload = value end
    end
  end

  self.wpn_fps_sho_x_basset.override.wpn_fps_sho_basset_m_extended.stats.extra_ammo = 10 -- Grimm/Izhma extended mag

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
    "wpn_fps_sho_coach", "wpn_fps_sho_ultima", "wpn_fps_sho_sko12", "wpn_fps_sho_x_sko12", "wpn_fps_sho_supernova" }
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
end)