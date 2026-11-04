local attachments = {
  -- Gadgets
  light = { concealment = -1, recoil = 2, value = 3 },
  stealth_light = { recoil = 1, value = 3 },
  laser = { concealment = -1, spread = 2, spread_moving = 2, value = 5 },
  stealth_laser = { spread = 1, spread_moving = 1, value = 5 },
  laser_light = { concealment = -2, spread = 1, spread_moving = 1, recoil = 1, value = 8 },

  -- Sights
  no_zoom = { concealment = -1, recoil = 1, value = 6 },
  low_zoom = { concealment = -2, recoil = 2, value = 6, increase_zoom = true },
  high_zoom = { concealment = -2, spread = 2, spread_moving = 2, value = 6 },
  piggyback = { concealment = -3, recoil = 1, spread = 1, spread_moving = 1, value = 8 },
  scope = { concealment = -1, recoil = 1, spread = 2, spread_moving = 2, value = 9 },
  iron_sight = { spread = 1, spread_moving = 1, value = 4 },
  sniper_iron = { concealment = 2, value = 4 },

  -- Mags
  quadstack = { extra_ammo = 30, reload = -2 },
  low_capacity = { extra_ammo = -10, reload = 10 },
  quickpull = { reload = 4 },

  -- Barrels
  dmr_kit = { fire_rate_multiplier = 0.8, ammo_pickup_min_mul = 0.5, ammo_pickup_max_mul = 0.5 },
  short_barrel = { fire_rate_multiplier = 1.1, ammo_pickup_min_mul = 1.05, ammo_pickup_max_mul = 1.05 }
}

Global.CrimDusk.weapon_parts = {
  mags = {
    wpn_fps_sho_basset_m_extended = { MagChange = 5, ReloadSpeed = -4 },
    wpn_fps_sho_aa12_mag_drum = { MagChange = 12, ReloadSpeed = -4 },
    wpn_fps_m4_uupg_m_std = { MagChange = 10, ReloadSpeed = -2 },
    wpn_fps_sho_bleckert_magazine_horse = { MagChange = 2, ReloadSpeed = -1 },

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
    wpn_fps_ass_famas_b_sniper = { fire_rate_multiplier = 0.5, ammo_pickup_min_mul = 0.34, ammo_pickup_max_mul = 0.34 },
    wpn_fps_ass_vhs_b_sniper = { fire_rate_multiplier = 0.5, ammo_pickup_min_mul = 0.34, ammo_pickup_max_mul = 0.34 },
    wpn_fps_ass_galil_fg_sniper = attachments.dmr_kit,

    wpn_fps_ass_g3_b_short = attachments.short_barrel,
    wpn_fps_ass_famas_b_short = attachments.short_barrel,
    wpn_fps_ass_vhs_b_short = attachments.short_barrel,
    wpn_fps_ass_asval_b_proto = attachments.short_barrel,
    wpn_fps_ass_galil_fg_mar = attachments.short_barrel,
    wpn_fps_ass_fal_body_standard = attachments.short_barrel,
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
    wpn_fps_upg_o_schmidt = { concealment = -1, recoil = 1, spread = 2, spread_moving = 2, zoom = 8, value = 9 },
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

    -- Pistol sights
    wpn_fps_upg_o_rmr = { concealment = -1, recoil = 1, value = 6 },
    wpn_fps_upg_o_rikt = { concealment = -2, recoil = 2, value = 6 },
    wpn_fps_upg_o_rms = { value = 4 },

    -- Secondary sights
    wpn_fps_upg_o_45rds = { concealment = -2, recoil = 1, spread = -1, spread_moving = -1, value = 4 },
    wpn_fps_upg_o_45rds_v2 = { concealment = -2, recoil = 1, spread = -1, spread_moving = -1, value = 4 },
    wpn_fps_upg_o_xpsg33_magnifier = { concealment = -2, recoil = -1, spread = 1, spread_moving = 1, value = 4 },
    wpn_fps_upg_o_45iron = { value = 4 },
    wpn_fps_upg_o_45steel = { value = 4 },
    wpn_fps_upg_o_sig = { concealment = -2, recoil = -1, spread = 1, spread_moving = 1, value = 4 },

    -- Upper receiver
    wpn_fps_upg_ak_body_upperreceiver_zenitco = { recoil = 1, spread = -1, spread_moving = -1, value = 1 },

    -- Lower receiver
    wpn_fps_ass_tkb_body_pouch = { concealment = -2, recoil = 1, spread = -1, total_ammo_mod = 5, value = 1 },

    -- Barrels
    wpn_fps_upg_ass_m4_b_beowulf = { concealment = -4, damage = 50, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 }, -- DMR kit
    wpn_fps_upg_ass_ak_b_zastava = { concealment = -4, damage = 49, coil = -3, spread = 2, total_ammo_mod = -12, value = 1 }, -- DMR kit
    wpn_fps_ass_g3_b_sniper = { concealment = -2, damage = 50, extra_ammo = -10, recoil = -1, spread = 2, total_ammo_mod = -8, value = 2 }, -- DMR kit
    wpn_fps_ass_shak12_body_vks = { concealment = -4, damage = 49, coil = -3, spread = 2, total_ammo_mod = -12, value = 1 }, -- DMR kit
    wpn_fps_ass_famas_b_sniper = { concealment = -4, damage = 51, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 }, -- DMR kit
    wpn_fps_ass_vhs_b_sniper = { concealment = -4, damage = 51, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 }, -- DMR kit
    wpn_fps_ass_galil_fg_sniper = { concealment = -4, damage = 43, recoil = -10, spread = 4, total_ammo_mod = -12, value = 1 }, -- DMR kit

    wpn_fps_ass_g3_b_short = { concealment = 4, damage = -8, recoil = 5, spread = -4, total_ammo_mod = 4, value = 2 }, -- Short barrel
  }
}