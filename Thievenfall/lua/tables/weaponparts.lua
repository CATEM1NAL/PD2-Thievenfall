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
  sniper_iron = { concealment = 2, value = 4 }
}

Global.CrimDusk.weapon_parts = {
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
}