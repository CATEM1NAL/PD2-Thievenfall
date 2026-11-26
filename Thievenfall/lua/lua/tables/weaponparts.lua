local attachments = {
  -- Gadgets
  light = { concealment = -1, recoil = 2, value = 3 },
  stealth_light = { recoil = 1, value = 3 },
  laser = { concealment = -1, spread = 2, value = 5 },
  stealth_laser = { spread = 1, value = 5 },
  laser_light = { concealment = -2, spread = 1, recoil = 1, value = 8 },

  -- Sights
  no_zoom = { concealment = -1, recoil = 1, value = 6 },
  low_zoom = { concealment = -2, recoil = 2, zoom = 4, value = 6 },
  high_zoom = { concealment = -2, spread = 2, zoom = 5, value = 6 },
  piggyback = { concealment = -3, recoil = 1, zoom = 6, spread = 1 },
  scope = { concealment = -1, recoil = 1, spread = 2, value = 9 },
  iron_sight = { spread = 1, value = 4 },
  sniper_iron = { concealment = 2, value = 4 },

  -- Mags
  quadstack = { extra_ammo = 30, reload = -2 },
  low_capacity = { extra_ammo = -10, reload = 10 },
  quickpull = { reload = 4 },

  -- Barrels
  dmr_kit = { fire_rate_multiplier = 0.75, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.5, movement_speed = 0.95 },
  short_barrel = { fire_rate_multiplier = 1.1, ammo_pickup_min_mul = 1.05, ammo_pickup_max_mul = 1.05, movement_speed = 1.05 },

  -- Barrel ext.
  muzzle_brake = { concealment = -1, alert_size = -1, recoil = 2, suppression = -2, value = 5 },
  flash_hider = { concealment = -1, recoil = 1, spread = 1, value = 5 },
  suppressor_small = { concealment = -2, alert_size = 6, damage = -1, spread = 2, suppression = 5, value = 2 },
  suppressor_med = { concealment = -3, alert_size = 9, damage = -3, spread = 3, suppression = 10, value = 2 },
  suppressor_large = { concealment = -4, alert_size = 12, damage = -5, spread = 4, suppression = 15, value = 2 },
}

Global.CrimDusk.weapon_parts = {
  mags = {
    wpn_fps_upg_m4_m_straight_vanilla = { reload = 10 },

    wpn_fps_sho_basset_m_extended = { extra_ammo = 5, reload = -4 },
    wpn_fps_sho_aa12_mag_drum = { extra_ammo = 12, reload = -4 },
    wpn_fps_m4_uupg_m_std = { extra_ammo = 10 },
    wpn_fps_sho_bleckert_magazine_horse = { extra_ammo = 2, reload = -1 },
    wpn_fps_smg_shepheard_mag_extended = { extra_ammo = 10, reload = -2 },

    wpn_fps_upg_m4_m_quad = attachments.quadstack,
    wpn_fps_upg_ak_m_quad = attachments.quadstack,

    wpn_fps_smg_p90_m_strap = attachments.quickpull,
    wpn_fps_ass_aug_m_quick = attachments.quickpull,
    wpn_fps_m4_upg_m_quick = attachments.quickpull,
    wpn_fps_upg_ak_m_quick = attachments.quickpull,
    wpn_fps_ass_g36_m_quick = attachments.quickpull,
    wpn_fps_smg_mac10_m_quick = attachments.quickpull,
    wpn_fps_smg_sr2_m_quick = attachments.quickpull,

    wpn_fps_upg_m4_m_straight = attachments.low_capacity,
  },

  custom_stats = {
    wpn_fps_upg_ass_m4_b_beowulf = attachments.dmr_kit,
    wpn_fps_upg_ass_ak_b_zastava = attachments.dmr_kit,
    wpn_fps_ass_g3_b_sniper = attachments.dmr_kit,
    wpn_fps_ass_shak12_body_vks = attachments.dmr_kit,
    wpn_fps_ass_famas_b_sniper = { fire_rate_multiplier = 0.5, ammo_pickup_min_mul = 0.34, ammo_pickup_max_mul = 0.34, movement_speed = 0.95 },
    wpn_fps_ass_vhs_b_sniper = { fire_rate_multiplier = 0.5, ammo_pickup_min_mul = 0.34, ammo_pickup_max_mul = 0.34, movement_speed = 0.95 },
    wpn_fps_ass_galil_fg_sniper = attachments.dmr_kit,

    wpn_fps_ass_g3_b_short = attachments.short_barrel,
    wpn_fps_ass_famas_b_short = attachments.short_barrel,
    wpn_fps_ass_vhs_b_short = attachments.short_barrel,
    wpn_fps_ass_asval_b_proto = attachments.short_barrel,
    wpn_fps_ass_galil_fg_mar = attachments.short_barrel,
    wpn_fps_ass_fal_fg_01 = attachments.short_barrel,
    wpn_fps_ass_scar_b_short = attachments.short_barrel,
    wpn_fps_ass_corgi_b_short = attachments.short_barrel,
    wpn_fps_m4_uupg_b_short = attachments.short_barrel,
    wpn_fps_aug_b_short = attachments.short_barrel,
    wpn_fps_ass_ak5_b_short = attachments.short_barrel,
    wpn_fps_upg_ak_b_draco = attachments.short_barrel,
    wpn_fps_smg_mp5_fg_m5k = attachments.short_barrel,

    wpn_fps_lmg_m134_barrel_short = { movement_speed = 1.25 },
    wpn_fps_lmg_m134_body_upper_light = { movement_speed = 1.25 },

    wpn_fps_upg_i_singlefire = { fire_rate_multiplier = 0.5 },
    wpn_fps_upg_i_autofire = { fire_rate_multiplier = 1.1 },
    wpn_fps_upg_i_burstfire = { fire_rate_multiplier = 1.25 }
  },

  stats = {
    -- Primary gadgets
    wpn_fps_upg_fl_ass_smg_sho_surefire = attachments.light,
    wpn_fps_upg_fl_ass_smg_sho_peqbox = attachments.laser,
    wpn_fps_upg_fl_ass_laser = attachments.stealth_laser,
    wpn_fps_upg_fl_ass_peq15 = attachments.laser_light,
    wpn_fps_upg_fl_ass_utg = attachments.laser_light,
    wpn_fps_upg_fl_dbal_laser = attachments.stealth_laser,

    -- Secondary gadgets
    wpn_fps_upg_fl_pis_tlr1 = attachments.stealth_light,
    wpn_fps_upg_fl_pis_laser = attachments.stealth_laser,
    wpn_fps_upg_fl_pis_perst = attachments.laser,
    wpn_fps_upg_fl_pis_m3x = attachments.light,
    wpn_fps_upg_fl_pis_crimson = attachments.stealth_laser,
    wpn_fps_upg_fl_pis_x400v = attachments.laser_light,

    -- Sights
    wpn_fps_upg_o_eotech = attachments.low_zoom,
    wpn_fps_upg_o_t1micro = attachments.low_zoom,
    wpn_fps_upg_o_docter = attachments.no_zoom,
    wpn_fps_upg_o_acog = attachments.high_zoom,
    wpn_fps_upg_o_aimpoint = attachments.high_zoom,
    wpn_fps_upg_o_aimpoint_2 = attachments.high_zoom, -- Preorder sight
    wpn_fps_upg_o_specter = attachments.piggyback,
    wpn_fps_upg_o_cmore = attachments.no_zoom,
    wpn_fps_upg_o_cs = attachments.piggyback,
    wpn_fps_upg_o_eotech_xps = attachments.no_zoom,
    wpn_fps_upg_o_reflex = attachments.no_zoom,
    wpn_fps_upg_o_rx01 = attachments.low_zoom,
    wpn_fps_upg_o_rx30 = attachments.no_zoom,
    wpn_fps_upg_o_spot = attachments.high_zoom,
    wpn_fps_upg_o_tf90 = attachments.high_zoom,
    wpn_fps_upg_o_fc1 = attachments.no_zoom,
    wpn_fps_upg_o_uh = attachments.low_zoom,
    wpn_fps_upg_o_hamr = attachments.piggyback,
    wpn_fps_upg_o_health = attachments.no_zoom,
    wpn_fps_upg_o_bmg = attachments.high_zoom,
    wpn_fps_upg_o_atibal = attachments.piggyback,
    wpn_fps_upg_o_poe = attachments.high_zoom,
    wpn_fps_upg_o_leupold = attachments.scope,
    wpn_fps_upg_o_box = attachments.scope,
    wpn_fps_upg_o_northtac = attachments.scope,
    wpn_fps_upg_o_schmidt = { concealment = -1, recoil = 1, spread = 2, zoom = 8, value = 9 },
    wpn_fps_upg_o_schmidt_magnified = { gadget_zoom = 5, value = 1 },
    wpn_fps_upg_winchester_o_classic = attachments.scope,
    wpn_fps_upg_o_mbus_pro = attachments.sniper_iron,
    wpn_fps_snp_siltstone_iron_sight = attachments.sniper_iron,
    wpn_fps_snp_model70_iron_sight = attachments.sniper_iron,
    wpn_fps_snp_awp_o_irons = attachments.sniper_iron,
    wpn_fps_snp_sbl_o_standard = attachments.sniper_iron,
    wpn_fps_snp_qbu88_o_standard = attachments.sniper_iron,
    wpn_fps_snp_mosin_iron_sight = attachments.sniper_iron,
    wpn_upg_o_marksmansight_rear = attachments.iron_sight,
    wpn_fps_upg_o_ak_scopemount = { value = 2 }, -- AK scope mount
    wpn_fps_upg_o_dardar = attachments.no_zoom,
    wpn_fps_upg_contender_o_ironsight = attachments.iron_sight,
    wpn_fps_snp_scout_o_iron_up = attachments.iron_sight,

    -- Pistol sights
    wpn_fps_upg_o_rmr = { concealment = -1, recoil = 1, value = 6 },
    wpn_fps_upg_o_rikt = { concealment = -2, recoil = 2, value = 6 },
    wpn_fps_upg_o_rms = { value = 4 },

    -- Secondary sights
    wpn_fps_upg_o_45rds = { concealment = -2, recoil = 1, spread = -1, value = 4 },
    wpn_fps_upg_o_45rds_v2 = { concealment = -2, recoil = 1, spread = -1, value = 4 },
    wpn_fps_upg_o_xpsg33_magnifier = { concealment = -2, recoil = -1, spread = 1, value = 4 },
    wpn_fps_upg_o_45iron = { value = 4 },
    wpn_fps_upg_o_45steel = { value = 4 },
    wpn_fps_upg_o_sig = { concealment = -2, recoil = -1, spread = 1, value = 4 },

    -- Upper receiver
    wpn_fps_upg_ak_body_upperreceiver_zenitco = { recoil = 1, spread = -1, value = 1 },

    -- Lower receiver
    wpn_fps_ass_tkb_body_pouch = { concealment = -2, recoil = 1, spread = -1, total_ammo_mod = 5, value = 1 },
    wpn_fps_lmg_m134_body_upper_light = { total_ammo_mod = -10, recoil = 3, spread = -3, value = 1 },

    -- DMR kits
    wpn_fps_upg_ass_m4_b_beowulf = { concealment = -4, damage = 50, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 },
    wpn_fps_upg_ass_ak_b_zastava = { concealment = -4, damage = 49, coil = -3, spread = 2, total_ammo_mod = -12, value = 1 },
    wpn_fps_ass_g3_b_sniper = { concealment = -2, damage = 50, extra_ammo = -10, recoil = -1, spread = 2, total_ammo_mod = -8, value = 2 },
    wpn_fps_ass_shak12_body_vks = { damage = 49, coil = -3, spread = 2, total_ammo_mod = -12, value = 1 },
    wpn_fps_ass_famas_b_sniper = { concealment = -4, damage = 51, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 },
    wpn_fps_ass_vhs_b_sniper = { concealment = -4, damage = 51, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 },
    wpn_fps_ass_galil_fg_sniper = { concealment = -4, damage = 43, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 },
    wpn_fps_smg_mp5_m_straight = { concealment = -1, damage = 8, recoil = -5, value = 1 },

    -- Short barrels
    wpn_fps_ass_g3_b_short = { concealment = 4, damage = -8, recoil = 5, spread = -4, total_ammo_mod = 4, value = 2 },
    wpn_fps_lmg_m134_barrel_short = { concealment = 3, recoil = 3, spread = -3, value = 1 },
    wpn_fps_ass_galil_fg_mar = { concealment = 4, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_famas_b_short = { concealment = 2, damage = -6, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_scar_b_short = { concealment = 2, damage = -26, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_corgi_b_short = { concealment = 4, damage = -6, recoil = 2, spread = -4, value = 2 },
    wpn_fps_m4_uupg_b_short = { concealment = 2, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_aug_b_short = { concealment = 4, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_vhs_b_short = { concealment = 2, damage = -6, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_asval_b_proto = { concealment = 4, damage = -6, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_ak5_b_short = { concealment = 2, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_ass_fal_fg_01 = { concealment = 4, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_upg_ak_b_draco = { concealment = 4, damage = -8, recoil = 2, spread = -4, value = 2 },
    wpn_fps_smg_mp5_fg_m5k = { concealment = 3, damage = -6, recoil = 2, spread = -4, value = 2 },

    -- Long barrels
    wpn_fps_lmg_m134_barrel_extreme = { concealment = -1, recoil = -3, spread = 3, value = 1 },

    -- Fire mode
    wpn_fps_upg_i_singlefire = { recoil = -3, spread = 2, value = 5 },
    wpn_fps_upg_i_autofire = { recoil = 2, spread = -1, value = 8 },
    wpn_fps_upg_i_burstfire = { recoil = -2, spread = 1, value = 8 },

    -- Barrel Extensions
    wpn_fps_upg_ns_ass_smg_stubby = attachments.flash_hider,
    wpn_fps_upg_ns_ass_smg_tank = attachments.muzzle_brake,
    wpn_fps_upg_ns_ass_smg_firepig = attachments.flash_hider,
    wpn_fps_upg_ass_ns_jprifles = attachments.muzzle_brake,
    wpn_fps_upg_ass_ns_linear = attachments.flash_hider,
    wpn_fps_upg_ass_ns_surefire = attachments.muzzle_brake,
    wpn_fps_upg_ass_ns_battle = attachments.flash_hider,
    wpn_fps_upg_ns_ass_smg_v6 = attachments.muzzle_brake,
    wpn_fps_lmg_hk51b_ns_jcomp = attachments.muzzle_brake,
    wpn_fps_ass_shak12_ns_muzzle = attachments.muzzle_brake,
    wpn_fps_lmg_kacchainsaw_ns_muzzle = attachments.flash_hider,
    wpn_fps_upg_pis_ns_flash = attachments.flash_hider,
    wpn_fps_upg_ns_pis_ipsccomp = attachments.flash_hider,
    wpn_fps_upg_ns_pis_meatgrinder = attachments.flash_hider,
    wpn_fps_upg_ns_pis_typhoon = attachments.muzzle_brake,
    wpn_fps_upg_ak_ns_zenitco = attachments.muzzle_brake,
    wpn_fps_upg_ak_ns_jmac = attachments.flash_hider,
    wpn_fps_snp_siltstone_ns_variation_b = attachments.flash_hider,
    wpn_fps_upg_ns_shot_shark = attachments.muzzle_brake,
    wpn_fps_upg_shot_ns_king = attachments.flash_hider,
    wpn_fps_upg_ns_duck = { concealment = -2, value = 1, spread_multi = { 2, 0.5 } },

    wpn_fps_upg_ns_ass_smg_small = attachments.suppressor_small,
    wpn_fps_upg_ns_pis_small = attachments.suppressor_small,
    wpn_fps_lmg_kacchainsaw_ns_suppressor = attachments.suppressor_small,
    wpn_fps_upg_ns_shot_thick = attachments.suppressor_small,

    wpn_fps_upg_ns_ass_smg_medium = attachments.suppressor_med,
    wpn_fps_upg_ns_pis_medium = attachments.suppressor_med,
    wpn_fps_upg_ns_sho_salvo_large = attachments.suppressor_med,
    wpn_fps_upg_ns_pis_medium_slim = attachments.suppressor_med,
    wpn_fps_upg_ns_pis_medium_gem = attachments.suppressor_med,
    wpn_fps_upg_ns_pis_putnik = attachments.suppressor_med,
    wpn_fps_upg_ak_ns_tgp = attachments.suppressor_med,

    wpn_fps_upg_ns_ass_smg_large = attachments.suppressor_large,
    wpn_fps_upg_ns_pis_large = attachments.suppressor_large,
    wpn_fps_ass_shak12_ns_suppressor = attachments.suppressor_large,
    wpn_fps_upg_ns_pis_large_kac = attachments.suppressor_large,
    wpn_fps_upg_ns_pis_jungle = attachments.suppressor_large,
    wpn_fps_upg_ns_ass_pbs1 = attachments.suppressor_large,
    wpn_fps_snp_siltstone_b_silenced = attachments.suppressor_large,
    wpn_fps_smg_mp7_b_suppressed = attachments.suppressor_large,

    wpn_fps_upg_ns_ass_filter = { concealment = -3, alert_size = 6, damage = -3, suppression = 5, value = 2 },
    wpn_fps_smg_mp5_fg_mp5sd = { concealment = -2, alert_size = 12, damage = -3, spread = 4, suppression = 15, value = 2 },

    -- Stocks
    wpn_fps_snp_scout_s_pads_one = { concealment = 1, recoil = -1, spread = -1 },
  }
}