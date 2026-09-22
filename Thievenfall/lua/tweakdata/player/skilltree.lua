local function digest(value)
  return Application:digest_value(value, true)
end

Hooks:PostHook(SkillTreeTweakData, "init", "CrimDusk_SkillTreeTweakInit", function(self)
    self.tier_unlocks = { digest(0), digest(0), digest(0), digest(0) }
    self.tier_cost = { { 1, 1, 1, 1 }, { 2, 2, 2, 2 }, { 3, 3, 3, 3 }, { 4, 4, 4, 4 } }

    -- Default upgrades
    self.default_upgrades = {
      "player_fall_health_damage_multiplier",
      "player_hostage_trade",
      "player_intimidate_enemies",
      "player_special_enemy_highlight",
      "player_special_enemy_highlight_mask_off",
      "player_sec_camera_highlight",
      "player_sec_camera_highlight_mask_off",
      "player_mask_off_pickup",
      "player_corpse_dispose",
      "player_corpse_dispose_amount_1",
      "carry_interact_speed_multiplier_1",
      "carry_interact_speed_multiplier_2",
      "carry_movement_speed_multiplier",
      "trip_mine_can_switch_on_off",
      "striker_reload_speed_default",
      "temporary_first_aid_damage_reduction",
      "temporary_passive_revive_damage_reduction_2",
      "akimbo_recoil_index_addend_1",
      "body_armor1",
      "cable_tie_quantity_unlimited",
      "doctor_bag",
      "ammo_bag",
      "trip_mine",
      "ecm_jammer",
      "first_aid_kit",
      "sentry_gun",
      "bodybags_bag",
      "cable_tie",
      "jowi",
      "x_1911",
      "x_b92fs",
      "x_deagle",
      "x_g22c",
      "x_g17",
      "x_usp",
      "x_sr2",
      "x_mp5",
      "x_akmsu",
      "x_packrat",
      "x_p226",
      "x_m45",
      "x_mp7",
      "x_ppk"
    }

    table.insert(self.default_upgrades, "temporary_chico_injector_1")
    table.insert(self.default_upgrades, "player_tag_team_base")
    table.insert(self.default_upgrades, "player_tag_team_cooldown_drain_1")
    table.insert(self.default_upgrades, "player_pocket_ecm_jammer_base")
    table.insert(self.default_upgrades, "temporary_copr_ability_1")
    table.insert(self.default_upgrades, "player_copr_static_damage_ratio_1")
    table.insert(self.default_upgrades, "player_copr_kill_life_leech_1")

    -- Disable perk decks
    for i = 1, #self.specializations do
      for _, data in ipairs(self.specializations[i]) do
        if data.upgrades and next(data.upgrades) then data.upgrades = {} end
      end
    end

    -- Mastermind
    self.trees[1].tiers = {
      { "healing_damage_reduction", "revived_bonus_heal", "healing_deploy_speed" },
      { "fak_capacity", "revived_player_reduction", "docbag_capacity" },
      { "revive_reduction", "code_blue", "docbag_quantity" },
      { "uppers", "inspire", "fak_lives" }
    }
    self.trees[2].name_id = "st_menu_mastermind_single_shot"
    self.trees[2].tiers = {
      { "stable_shot" },
      { "target_acquisition", "spotter_teamwork" },
      { "trigger_happy", "speedy_reload", "long_shot" },
      { "helmet_popping", "coup_de_grace", "single_shot_ammo_return" }
    }
    self.trees[3].name_id = "st_menu_mastermind_dominate"
    self.trees[3].tiers = {
      { "cable_guy", "blanks", "deep_throat" },
      { "oldholm_syndrome", "crowd_control", "custody_timer" },
      { "stockholm_syndrome", "joker", "dominator" },
      { "joker_dr", "joker_player_stats", "joker_damage" }
    }

    -- Enforcer
    self.trees[4].name_id = "st_menu_enforcer_ammo"
    self.trees[4].tiers = {
      { "scavenger", "max_ammo_increase", "extra_ammo_box", "portable_saw" },
      { "ammobag_capacity", "gambler_heal", "carbon_blade" },
      { "ammobag_quantity", "ammo_reservoir" },
      { "fully_loaded", "gambler_mag_throw", "scrounger" }
    }
    self.trees[5].name_id = "st_menu_enforce_shotgun"
    self.trees[5].tiers = {
      { "heavy_impact", "mobile", "threat_inc", "downed_ads" },
      { "perk_dmg", "fire_control", "shotgun_accuracy", "loud_and_proud" },
      { "lock_load", "shotgun_range", "muscle_panic", "shell_dimension" },
      { "body_expertise", "sprint_shoot", "overkill" }
    }
    self.trees[6].name_id = "st_menu_enforcer_armor"
    self.trees[6].tiers = {
      { "transporter", "armorer_perk", "stun_resistance" },
      { "armor_bag_reduction", "juggernaut" },
      { "shock_awe", "nerves_of_steel" },
      { "crew_recovery", "maniac_base" }
    }

    -- Technician
    self.trees[7].tiers = {
      { "sentry_rotation", "sentry_accuracy" },
      { "sentry_ammo", "sentry_health" },
      { "sentry_ap", "tower_defense" },
      { "jack_of_all_trades", "sentry_shield" }
    }
    self.trees[8].name_id = "st_menu_technician_auto"
    self.trees[8].tiers = {
      { "stability_increase" },
      { "accuracy_increase", "tinkerer" },
      { "reload_speed", "hollow_point" },
      { "illegal_parts", "mag_plus" }
    }
    self.trees[9].name_id = "st_menu_technician_breaching"
    self.trees[9].tiers = {
      { "toolkit", "silent_drilling", "trip_mine_radius" },
      { "drill_expert", "trip_mine_damage", "trip_mine_quantity" },
      { "kick_starter", "fire_trap", "sensor_mines" },
      { "drill_restart", "shaped_charge" }
    }

    -- Ghost
    self.trees[10].tiers = {
      { "cleaner", "burglar_stealth", "ecm_duration" },
      { "chameleon", "cam_loop", "ecm_overdrive" },
      { "lockpick_speed", "ecm_feedback" },
      { "ecm_quantity" }
    }
    self.trees[11].name_id = "st_menu_ghost_silencer"
    self.trees[11].tiers = {
      { "quick_draw", "hidden_blade", "vest_conceal", "high_value_target" },
      { "copycat_reload", "akimbo", "silence_expert" },
      { "dire_need", "backstab", "silence_conceal" },
      { "pager_snatch", "hypocritical", "silencer_statboost" }
    }
    self.trees[12].name_id = "st_menu_ghost_concealed"
    self.trees[12].tiers = {
      { "rogue_dodge", "moving_target", "daredevil", "move_speed" },
      { "crook_skill", "crouch_dodge", "shockproof", "jail_diet" },
      { "ex_pres", "optical_illusion", "second_wind" },
      { "anarch_rise", "sprint_loaded" }
    }

    -- Convict
    self.trees[13].tiers = {
      { "h3h3_cooldown", "kingpin_cooldown", "leech_duration" },
      { "stoic_base", "kingpin_prio", "leech_healing" },
      { "stoic_regen", "kingpin_healing", "leech_segments" },
      { "stoic_negation", "h3h3_absorb", "kingpin_base", "leech_swan" }
    }
    self.trees[14].name_id = "st_menu_fugitive_berserker"
    self.trees[14].tiers = {
      { "hitman_perk", "steroids", "because_of_training" },
      { "yakuza_speed", "infil_melee", "melee_reload_speed" },
      { "sharp_damage", "drop_soap", "infil_heal", "berserker" },
      { "bloodthirst", "frenzy", "gunserker" }
    }
    self.trees[15].name_id = "st_menu_fugitive_undead"
    self.trees[15].tiers = {
      { "muscle_health", "revive_swap_speed" },
      { "four_lives", "revive_move_speed" },
      { "swan_song", "messiah" },
      { "vengeful_swan", "feign_death" }
    }

    -- Skill definitions
    self.skills.temp_skill = {
      name_id = "temp_skill_name", desc_id = "temp_desc", icon_xy = { 0, 0 }
    }
    self.skills.revive_reduction = {
      { upgrades = { "player_revive_damage_reduction_1" }, cost = self.costs.default },
      { upgrades = { "temporary_revive_damage_reduction_1" }, cost = self.costs.default },
      name_id = "menu_combat_medic_beta", desc_id = "menu_revive_reduction_desc", icon_xy = { 6, 6 }
    }
    self.skills.revived_player_reduction = {
      { upgrades = { "player_revive_damage_reduction_level_1" }, cost = self.costs.default },
      { upgrades = { "player_revive_damage_reduction_level_2" }, cost = self.costs.default },
      name_id = "menu_fast_learner_beta", desc_id = "menu_fast_learner_beta_desc", icon_xy = { 0, 10 }
    }
    self.skills.revived_bonus_heal = {
      { upgrades = { "player_revive_health_boost" }, cost = self.costs.default },
      { upgrades = { "player_revive_health_boost_2" }, cost = self.costs.default },
      name_id = "menu_reviver_bonus_heal", desc_id = "menu_reviver_bonus_heal_desc", icon_xy = { 5, 7 }
    }
    self.skills.healing_deploy_speed = {
      { upgrades = { "first_aid_kit_deploy_time_multiplier" }, cost = self.costs.default },
      name_id = "menu_tea_time_beta", desc_id = "menu_tea_time_beta_desc", icon_xy = { 1, 11 }
    }
    self.skills.healing_damage_reduction = {
      { upgrades = { "first_aid_kit_damage_reduction_upgrade" }, cost = self.costs.default },
      name_id = "menu_healing_damage_reduction", desc_id = "menu_healing_damage_reduction_desc", icon_xy = { 1, 11 }
    }
    self.skills.fak_capacity = {
      { upgrades = { "first_aid_kit_quantity_increase_1" }, cost = self.costs.default },
      { upgrades = { "first_aid_kit_quantity_increase_2" }, cost = self.costs.default },
      name_id = "menu_fak_capacity", desc_id = "menu_fak_capacity_desc", icon_xy = { 2, 11 }
    }
    self.skills.uppers = {
      { upgrades = { "first_aid_kit_auto_recovery_1" }, cost = self.costs.default },
      name_id = "menu_tea_cookies_beta", desc_id = "menu_uppers_desc", icon_xy = { 3, 10 }
    }
    self.skills.docbag_quantity = {
      { upgrades = { "doctor_bag_quantity" }, cost = self.costs.default },
      { upgrades = { "doctor_bag_quantity_2" }, cost = self.costs.default },
      name_id = "menu_docbag_quantity", desc_id = "menu_docbag_quantity_desc", icon_xy = { 5, 8 }
    }
    self.skills.docbag_capacity = {
      { upgrades = { "doctor_bag_amount_increase1" }, cost = self.costs.default },
      { upgrades = { "doctor_bag_amount_increase_2" }, cost = self.costs.default },
      name_id = "menu_docbag_capacity", desc_id = "menu_docbag_capacity_desc", icon_xy = { 2, 7 }
    }
    self.skills.code_blue = {
      { upgrades = { "player_revive_interaction_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_code_blue", desc_id = "menu_code_blue_desc", icon_xy = { 4, 9 }
    }
    self.skills.inspire = {
      { upgrades = { "player_morale_boost" }, cost = self.costs.default },
      { upgrades = { "cooldown_long_dis_revive" }, cost = self.costs.default },
      name_id = "menu_inspire_beta", desc_id = "menu_inspire_beta_desc", icon_xy = { 4, 9 }
    }
    self.skills.fak_lives = {
      { upgrades = { "first_aid_kit_downs_restore_chance" }, cost = self.costs.default },
      { upgrades = { "first_aid_kit_downs_restore_chance_2" }, cost = self.costs.default },
      name_id = "menu_fak_lives", desc_id = "menu_fak_lives_desc", icon_xy = { 3, 10 }
    }
    self.skills.cable_guy = {
      { upgrades = { "cable_tie_interact_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "team_damage_hostage_absorption" }, cost = self.costs.default },
      name_id = "menu_cable_guy", desc_id = "menu_cable_guy_desc", icon_xy = { 4, 7 }
    }
    self.skills.deep_throat = {
      { upgrades = { "player_intimidate_range_mul" }, cost = self.costs.default },
      { upgrades = { "player_intimidate_range_mul_2" }, cost = self.costs.default },
      name_id = "menu_deep_throat", desc_id = "menu_deep_throat_desc", icon_xy = { 2, 8 }
    }
    self.skills.joker = {
      { upgrades = { "player_convert_enemies", "player_convert_enemies_max_minions_1" }, cost = self.costs.default },
      { upgrades = { "player_convert_enemies_interaction_speed_multiplier", "player_convert_enemies_max_minions_2" }, cost = self.costs.default },
      name_id = "menu_joker_beta", desc_id = "menu_joker_beta_desc", icon_xy = { 6, 8 }
    }
    self.skills.joker_damage = {
      { upgrades = { "player_convert_enemies_damage_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_convert_enemies_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_joker_damage", desc_id = "menu_joker_damage_desc", icon_xy = { 6, 8 }
    }
    self.skills.joker_dr = {
      { upgrades = { "player_passive_convert_enemies_health_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_passive_convert_enemies_health_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_joker_dr", desc_id = "menu_joker_dr_desc", icon_xy = { 6, 8 }
    }
    self.skills.joker_player_stats = {
      { upgrades = { "player_minion_master_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_minion_master_health_multiplier" }, cost = self.costs.default },
      name_id = "menu_control_freak_beta", desc_id = "menu_control_freak_beta_desc", icon_xy = { 1, 10 }
    }
    self.skills.stockholm_syndrome = {
      { upgrades = { "player_super_syndrome_1" }, cost = self.costs.default },
      name_id = "menu_stockholm_syndrome_beta", desc_id = "menu_stockholm_syndrome_beta_desc", icon_xy = { 3, 8 }
    }
    self.skills.crowd_control = {
      { upgrades = { "player_intimidate_aura" }, cost = self.costs.default },
      { upgrades = { "player_civ_calming_alerts" }, cost = self.costs.default },
      name_id = "menu_crowd_control", desc_id = "menu_crowd_control_desc", icon_xy = { 6, 7 }
    }
    self.skills.stable_shot = {
      { upgrades = { "player_not_moving_accuracy_increase_bonus_1" }, cost = self.costs.default },
      name_id = "menu_stable_shot_beta", desc_id = "menu_stable_shot_beta_desc", icon_xy = { 0, 5 }
    }
    self.skills.mobile = {
      { upgrades = { "player_steelsight_normal_movement_speed" }, cost = self.costs.default },
      name_id = "menu_mobile", desc_id = "menu_mobile_desc", icon_xy = { 6, 5 }
    }
    self.skills.target_acquisition = {
      { upgrades = { "weapon_enter_steelsight_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "assault_rifle_zoom_increase", "snp_zoom_increase", "smg_zoom_increase", "lmg_zoom_increase", "pistol_zoom_increase" }, cost = self.costs.default },
      name_id = "menu_target_acquisition", desc_id = "menu_target_acquisition_desc", icon_xy = { 6, 5 }
    }
    self.skills.speedy_reload = {
      { upgrades = { "temporary_single_shot_fast_reload_1" }, cost = self.costs.default },
      name_id = "menu_speedy_reload_beta", desc_id = "menu_speedy_reload_beta_desc", icon_xy = { 8, 3 }
    }
    self.skills.long_shot = {
      { upgrades = { "player_marked_inc_dmg_distance_1" }, cost = self.costs.default },
      name_id = "menu_long_shot", desc_id = "menu_long_shot_desc", icon_xy = { 8, 2 }
    }
    self.skills.overdog = {
      { upgrades = { "player_damage_dampener_close_contact_1" }, cost = self.costs.default },
      { upgrades = { "player_damage_dampener_close_contact_2" }, cost = self.costs.default },
      { upgrades = { "player_damage_dampener_close_contact_3" }, cost = self.costs.default },
      name_id = "menu_underdog_beta", desc_id = "menu_infil_close_desc", icon_xy = { 2, 1 }
    }
    self.skills.shotgun_impact = {
      { upgrades = { "shotgun_damage_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "shotgun_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_shotgun_impact_beta", desc_id = "menu_shotgun_impact_beta_desc", icon_xy = { 4, 1 }
    }
    self.skills.shotgun_stability = {
      { upgrades = { "shotgun_recoil_index_addend" }, cost = self.costs.default },
      name_id = "temp_skill_name", desc_id = "menu_shotgun_stability_desc", icon_xy = { 4, 1 }
    }
    self.skills.shotgun_reload = {
      { upgrades = { "shotgun_reload_speed_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "shotgun_reload_speed_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_shotgun_cqb_beta", desc_id = "menu_shotgun_cqb_beta_desc", icon_xy = { 5, 1 }
    }
    self.skills.shotgun_ads_speed = {
      { upgrades = { "shotgun_enter_steelsight_speed_multiplier" }, cost = self.costs.default },
      name_id = "temp_skill_name", desc_id = "menu_shotgun_ads_speed_desc", icon_xy = { 8, 5 }
    }
    self.skills.shotgun_rof = {
      { upgrades = { "shotgun_hip_rate_of_fire_1" }, cost = self.costs.default },
      name_id = "menu_shotgun_rof", desc_id = "menu_shotgun_rof_desc", icon_xy = { 8, 6 }
    }
    self.skills.shotgun_accuracy = {
      { upgrades = { "shotgun_steelsight_accuracy_inc_1" }, cost = self.costs.default },
      name_id = "menu_shotgun_accuracy", desc_id = "menu_shotgun_accuracy_desc", icon_xy = { 8, 5 }
    }
    self.skills.shotgun_range = {
      { upgrades = { "shotgun_steelsight_range_inc_1" }, cost = self.costs.default },
      name_id = "menu_far_away_beta", desc_id = "menu_far_away_beta_desc", icon_xy = { 8, 5 }
    }
    self.skills.overkill = {
      { upgrades = { "player_overkill_damage_multiplier", "player_overkill_all_weapons" }, cost = self.costs.default },
      name_id = "menu_overkill_beta", desc_id = "menu_overkill_beta_desc", icon_xy = { 3, 2 }
    }
    self.skills.crew_recovery = {
      { upgrades = { "team_armor_regen_time_multiplier" }, cost = self.costs.default },
      name_id = "menu_team_armor_regen", desc_id = "menu_team_armor_regen_desc", icon_xy = { 2, 12 }
    }
    self.skills.shock_awe = {
      { upgrades = { "player_shield_knock" }, cost = self.costs.default },
      name_id = "menu_iron_man_beta", desc_id = "menu_iron_man_beta_desc", icon_xy = { 8, 10 }
    }
    self.skills.nerves_of_steel = {
      { upgrades = { "player_interacting_damage_multiplier" }, cost = self.costs.default },
      name_id = "menu_nerves_of_steel_name", desc_id = "menu_nerves_of_steel_desc", icon_xy = { 8, 9 }
    }
    self.skills.transporter = {
      { upgrades = { "carry_throw_distance_multiplier" }, cost = self.costs.default },
      name_id = "menu_pack_mule_beta", desc_id = "menu_pack_mule_beta_desc", icon_xy = { 8, 8 }
    }
    self.skills.armor_bag_reduction = {
      { upgrades = { "player_armor_carry_bonus_1" }, cost = self.costs.default },
      { upgrades = { "carry_movement_penalty_nullifier" }, cost = self.costs.default },
      name_id = "menu_armor_bag_reduction", desc_id = "menu_armor_bag_reduction_desc", icon_xy = { 6, 0 }
    }
    self.skills.stun_resistance = {
      { upgrades = { "player_flashbang_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_flashbang_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_stun_resistance", desc_id = "menu_stun_resistance_desc", icon_xy = { 6, 1 }
    }
    self.skills.juggernaut = {
      { upgrades = { "body_armor6" }, cost = self.costs.default },
      name_id = "menu_juggernaut_beta", desc_id = "menu_juggernaut_beta_desc", icon_xy = { 3, 1 }
    }
    self.skills.extra_ammo_box = {
      { upgrades = { "player_double_drop_1" }, cost = self.costs.default },
      name_id = "menu_extra_ammo_box", desc_id = "menu_extra_ammo_box_desc", icon_xy = { 8, 11 }
    }
    self.skills.scavenger = {
      { upgrades = { "player_increased_pickup_area_1" }, cost = self.costs.default },
      name_id = "menu_scavenging_beta", desc_id = "menu_scavenger_desc", icon_xy = { 8, 11 }
    }
    self.skills.portable_saw = {
      { upgrades = { "saw" }, cost = self.costs.default },
      { upgrades = { "saw_secondary" }, cost = self.costs.default },
      name_id = "menu_portable_saw_beta", desc_id = "menu_portable_saw_desc", icon_xy = { 0, 1 }
    }
    self.skills.carbon_blade = {
      { upgrades = { "player_saw_speed_multiplier_2", "saw_lock_damage_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "saw_enemy_slicer", "saw_armor_piercing_chance" }, cost = self.costs.default },
      { upgrades = { "saw_ignore_shields_1", "saw_panic_when_kill_1" }, cost = self.costs.default },
      name_id = "menu_carbon_blade", desc_id = "menu_carbon_blade_desc", icon_xy = { 0, 2 }
    }
    self.skills.ammobag_quantity = {
      { upgrades = { "ammo_bag_quantity" }, cost = self.costs.default },
      { upgrades = { "ammo_bag_quantity_2" }, cost = self.costs.default },
      name_id = "menu_stockpile_name", desc_id = "menu_stockpile_desc", icon_xy = { 7, 1 }
    }
    self.skills.ammobag_capacity = {
      { upgrades = { "ammo_bag_ammo_increase1" }, cost = self.costs.default },
      { upgrades = { "ammo_bag_ammo_increase_2" }, cost = self.costs.default },
      name_id = "menu_ammobag_capacity", desc_id = "menu_ammobag_capacity_desc", icon_xy = { 1, 0 }
    }
    self.skills.fully_loaded = {
      { upgrades = { "player_pick_up_ammo_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_pick_up_ammo_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_bandoliers_beta", desc_id = "menu_fully_loaded_desc", icon_xy = { 3, 0 }
    }
    self.skills.scrounger = {
      { upgrades = { "player_regain_throwable_from_ammo_1" }, cost = self.costs.default },
      { upgrades = { "player_regain_throwable_from_ammo_2" }, cost = self.costs.default },
      name_id = "menu_scrounger_name", desc_id = "menu_scrounger_desc", icon_xy = { 3, 0 }
    }
    self.skills.max_ammo_increase = {
      { upgrades = { "extra_ammo_multiplier1" }, cost = self.costs.default },
      name_id = "menu_max_ammo_inc", desc_id = "menu_max_ammo_inc_desc", icon_xy = { 3, 0 }
    }
    self.skills.high_value_target = {
      { upgrades = { "weapon_steelsight_highlight_specials" }, cost = self.costs.default },
      { upgrades = { "player_marked_enemy_extra_damage" }, cost = self.costs.default },
      name_id = "menu_spotter_teamwork_beta", desc_id = "menu_spotter_teamwork_beta_desc", icon_xy = { 8, 2 }
    }
    self.skills.sentry_shield = {
      { upgrades = { "sentry_gun_shield" }, cost = self.costs.default },
      name_id = "menu_sentry_shield", desc_id = "menu_sentry_shield_desc", icon_xy = { 9, 0 }
    }
    self.skills.sentry_health = {
      { upgrades = { "sentry_gun_armor_multiplier" }, cost = self.costs.default },
      name_id = "menu_eco_sentry_beta", desc_id = "menu_eco_sentry_beta_desc", icon_xy = { 9, 2 }
    }
    self.skills.sentry_ammo = {
      { upgrades = { "sentry_gun_extra_ammo_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "sentry_gun_extra_ammo_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_sentry_ammo", desc_id = "menu_sentry_ammo_desc", icon_xy = { 5, 6 }
    }
    self.skills.sentry_accuracy = {
      { upgrades = { "sentry_gun_spread_multiplier" }, cost = self.costs.default },
      name_id = "menu_sentry_accuracy", desc_id = "menu_sentry_accuracy_desc", icon_xy = { 1, 6 }
    }
    self.skills.sentry_rotation = {
      { upgrades = { "sentry_gun_rot_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_sentry_rotation", desc_id = "menu_sentry_rotation_desc", icon_xy = { 1, 6 }
    }
    self.skills.sentry_ap = {
      { upgrades = { "sentry_gun_ap_bullets", "sentry_gun_fire_rate_reduction_1" }, cost = self.costs.default },
      name_id = "menu_sentry_ap", desc_id = "menu_sentry_ap_desc", icon_xy = { 7, 5 }
    }
    self.skills.jack_of_all_trades = {
      { upgrades = { "second_deployable_1" }, cost = self.costs.default },
      name_id = "menu_jack_of_all_trades_beta", desc_id = "menu_jack_of_all_trades_beta_desc", icon_xy = { 9, 4 }
    }
    self.skills.toolkit = {
      { upgrades = { "player_drill_fix_interaction_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_toolkit", desc_id = "menu_toolkit_desc", icon_xy = { 5, 5 }
    }
    self.skills.silent_drilling = {
      { upgrades = { "player_drill_alert" }, cost = self.costs.default },
      { upgrades = { "player_silent_drill" }, cost = self.costs.default },
      name_id = "menu_silent_drilling", desc_id = "menu_silent_drilling_desc", icon_xy = { 2, 6 }
    }
    self.skills.drill_restart = {
      { upgrades = { "player_drill_autorepair_1" }, cost = self.costs.default },
      { upgrades = { "player_drill_autorepair_2" }, cost = self.costs.default },
      name_id = "menu_drill_restart", desc_id = "menu_drill_restart_desc", icon_xy = { 5, 5 }
    }
    self.skills.trip_mine_damage = {
      { upgrades = { "trip_mine_damage_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "trip_mine_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_trip_mine_damage", desc_id = "menu_trip_mine_damage_desc", icon_xy = { 7, 4 }
    }
    self.skills.trip_mine_radius = {
      { upgrades = { "trip_mine_explosion_size_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "trip_mine_explosion_size_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_trip_mine_radius", desc_id = "menu_trip_mine_radius_desc", icon_xy = { 1, 5 }
    }
    self.skills.trip_mine_quantity = {
      { upgrades = { "trip_mine_quantity_increase_1" }, cost = self.costs.default },
      { upgrades = { "trip_mine_quantity_increase_2" }, cost = self.costs.default },
      name_id = "menu_trip_mine_quantity", desc_id = "menu_trip_mine_quantity_desc", icon_xy = { 2, 5 }
    }
    self.skills.shaped_charge = {
      { upgrades = { "shape_charge_quantity_increase_1" }, cost = self.costs.default },
      { upgrades = { "shape_charge_quantity_increase_2" }, cost = self.costs.default },
      { upgrades = { "shape_charge_quantity_increase_3" }, cost = self.costs.default },
      name_id = "menu_shaped_charge", desc_id = "menu_shaped_charge_desc", icon_xy = { 0, 7 }
    }
    self.skills.kick_starter = {
      { upgrades = { "player_drill_melee_hit_restart_chance_1" }, cost = self.costs.default },
      name_id = "menu_kick_starter_beta", desc_id = "menu_kick_starter_beta_desc", icon_xy = { 9, 8 }
    }
    self.skills.sensor_mines = {
      { upgrades = { "trip_mine_sensor_toggle", "trip_mine_sensor_highlight" }, cost = self.costs.default },
      name_id = "menu_sensor_mines", desc_id = "menu_sensor_mines_desc", icon_xy = { 6, 9 }
    }
    self.skills.fire_control = {
      { upgrades = { "player_hip_fire_accuracy_inc_1" }, cost = self.costs.default },
      name_id = "menu_fire_control_beta", desc_id = "menu_fire_control_beta_desc", icon_xy = { 9, 10 }
    }
    self.skills.lock_load = {
      { upgrades = { "player_automatic_faster_reload_1" }, cost = self.costs.default },
      name_id = "menu_shock_and_awe_beta", desc_id = "menu_shock_and_awe_beta_desc", icon_xy = { 10, 0 }
    }
    self.skills.sprint_shoot = {
      { upgrades = { "player_run_and_shoot_1" }, cost = self.costs.default },
      name_id = "menu_sprint_shoot", desc_id = "menu_sprint_shoot_desc", icon_xy = { 10, 0 }
    }
    self.skills.inside_man = {
      { upgrades = { "player_additional_assets" }, cost = self.costs.default },
      { upgrades = { "player_buy_bodybags_asset", "player_buy_spotter_asset" }, cost = self.costs.default },
      name_id = "menu_inside_man", desc_id = "menu_inside_man_desc", icon_xy = { 0, 8 }
    }
    self.skills.chameleon = {
      { upgrades = { "player_standstill_omniscience" }, cost = self.costs.default },
      name_id = "menu_chameleon_beta", desc_id = "menu_chameleon_beta_desc", icon_xy = { 6, 10 }
    }
    self.skills.cam_loop = {
      { upgrades = { "player_tape_loop_duration_1" }, cost = self.costs.default },
      { upgrades = { "player_tape_loop_duration_2" }, cost = self.costs.default },
      { upgrades = { "player_tape_loop_interact_distance_mul_1" }, cost = self.costs.default },
      name_id = "menu_cam_loop", desc_id = "menu_cam_loop_desc", icon_xy = { 4, 2 }
    }
    self.skills.lockpick_speed = {
      { upgrades = { "player_pick_lock_easy_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_pick_lock_hard" }, cost = self.costs.default },
      name_id = "menu_lockpick_speed", desc_id = "menu_lockpick_speed_desc", icon_xy = { 10, 4 }
    }
    self.skills.ecm_feedback = {
      { upgrades = { "ecm_jammer_can_activate_feedback", "ecm_jammer_interaction_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "ecm_jammer_can_retrigger" }, cost = self.costs.default },
      name_id = "menu_ecm_feedback", desc_id = "menu_ecm_feedback_desc", icon_xy = { 6, 2 }
    }
    self.skills.ecm_duration = {
      { upgrades = { "ecm_jammer_duration_multiplier", "ecm_jammer_feedback_duration_boost" }, cost = self.costs.default },
      { upgrades = { "ecm_jammer_duration_multiplier_2", "ecm_jammer_feedback_duration_boost_2" }, cost = self.costs.default },
      name_id = "menu_ecm_duration", desc_id = "menu_ecm_duration_desc", icon_xy = { 1, 4 }
    }
    self.skills.ecm_overdrive = {
      { upgrades = { "ecm_jammer_affects_cameras" }, cost = self.costs.default },
      { upgrades = { "ecm_jammer_affects_pagers" }, cost = self.costs.default },
      { upgrades = { "ecm_jammer_can_open_sec_doors" }, cost = self.costs.default },
      name_id = "menu_ecm_booster_beta", desc_id = "menu_ecm_overdrive_desc", icon_xy = { 6, 3 }
    }
    self.skills.ecm_quantity = {
      { upgrades = { "ecm_jammer_quantity_increase_1" }, cost = self.costs.default },
      { upgrades = { "ecm_jammer_quantity_increase_2" }, cost = self.costs.default },
      name_id = "menu_ecm_quantity", desc_id = "menu_ecm_quantity_desc", icon_xy = { 3, 4 }
    }
    self.skills.move_speed = {
      { upgrades = { "player_walk_speed_multiplier", "player_crouch_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_run_speed_multiplier", "player_run_dodge_chance" }, cost = self.costs.default },
      { upgrades = { "player_movement_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_move_speed", desc_id = "menu_move_speed_desc", icon_xy = { 1, 8 }
    }
    self.skills.moving_target = {
      { upgrades = { "player_can_strafe_run" }, cost = self.costs.default },
      { upgrades = { "player_can_free_run" }, cost = self.costs.default },
      name_id = "menu_moving_target", desc_id = "menu_moving_target_desc", icon_xy = { 2, 4 }
    }
    self.skills.sprint_loaded = {
      { upgrades = { "player_run_and_reload" }, cost = self.costs.default },
      name_id = "menu_sprint_loaded", desc_id = "menu_sprint_loaded_desc", icon_xy = { 10, 6 }
    }
    self.skills.hidden_blade = {
      { upgrades = { "player_melee_concealment_modifier" }, cost = self.costs.default },
      name_id = "menu_hidden_blade", desc_id = "menu_hidden_blade_desc", icon_xy = { 4, 10 }
    }
    self.skills.vest_conceal = {
      { upgrades = { "player_ballistic_vest_concealment_1" }, cost = self.costs.default },
      name_id = "menu_vest_conceal", desc_id = "menu_vest_conceal_desc", icon_xy = { 2, 12 }
    }
    self.skills.shockproof = {
      { upgrades = { "player_resist_firing_tased" }, cost = self.costs.default },
      { upgrades = { "player_ballistic_vest_concealment_1" }, cost = self.costs.default },
      { upgrades = { "player_taser_self_shock", "player_escape_taser_1" }, cost = self.costs.default },
      name_id = "menu_insulation_beta", desc_id = "menu_insulation_beta_desc", icon_xy = { 3, 5 }
    }
    self.skills.second_wind = {
      { upgrades = { "temporary_damage_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_team_damage_speed_multiplier_send" }, cost = self.costs.default },
      name_id = "menu_scavenger_beta", desc_id = "menu_scavenger_beta_desc", icon_xy = { 10, 9 }
    }
    self.skills.optical_illusion = {
      { upgrades = { "player_camouflage_bonus_1" }, cost = self.costs.default },
      { upgrades = { "player_camouflage_bonus_2" }, cost = self.costs.default },
      name_id = "menu_optic_illusions", desc_id = "menu_optic_illusions_desc", icon_xy = { 10, 10 }
    }
    self.skills.silence_expert = {
      { upgrades = { "weapon_silencer_recoil_index_addend" }, cost = self.costs.default },
      { upgrades = { "weapon_silencer_spread_index_addend" }, cost = self.costs.default },
      name_id = "menu_silence_expert_beta", desc_id = "menu_silence_expert_beta_desc", icon_xy = { 4, 4 }
    }
    self.skills.silence_conceal = {
      { upgrades = { "player_silencer_concealment_increase_1", "player_silencer_concealment_penalty_decrease_1" }, cost = self.costs.default },
      name_id = "menu_silence_conceal", desc_id = "menu_silence_conceal_desc", icon_xy = { 10, 10 }
    }
    self.skills.quick_draw = {
      { upgrades = { "weapon_passive_swap_speed_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "weapon_passive_swap_speed_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "weapon_swap_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_quick_draw", desc_id = "menu_rogue_switch", icon_xy = { 0, 9 }
    }
    self.skills.akimbo = {
      { upgrades = { "akimbo_recoil_index_addend_2" }, cost = self.costs.default },
      { upgrades = { "akimbo_recoil_index_addend_3" }, cost = self.costs.default },
      { upgrades = { "akimbo_recoil_index_addend_4" }, cost = self.costs.default },
      name_id = "menu_deck5_3", desc_id = "menu_akimbo_skill_beta_desc", icon_xy = { 3, 11 }
    }
    self.skills.coup_de_grace = {
      { upgrades = { "weapon_coup_de_grace" }, cost = self.costs.default },
      name_id = "menu_coup_de_grace", desc_id = "menu_coup_de_grace_desc", icon_xy = { 11, 2 }
    }
    self.skills.trigger_happy.icon_xy = { 7, 11 }
    self.skills.four_lives = {
      { upgrades = { "player_additional_lives_1" }, cost = self.costs.default },
      { upgrades = { "player_additional_lives_2" }, cost = self.costs.default },
      { upgrades = { "player_additional_lives_3" }, cost = self.costs.default },
      name_id = "menu_bleedout_timer_skill", desc_id = "menu_bleedout_timer_skill_desc", icon_xy = { 5, 2 }
    }
    self.skills.bleedout_health = {
      { upgrades = { "player_bleed_out_health_multiplier" }, cost = self.costs.default },
      name_id = "menu_bleedout_health", desc_id = "menu_bleedout_health_desc", icon_xy = { 1, 2 }
    }
    self.skills.bleedout_timer = {
      { upgrades = { "player_bleedout_timer_1" }, cost = self.costs.default },
      { upgrades = { "player_bleedout_timer_2" }, cost = self.costs.default },
      { upgrades = { "player_bleedout_timer_3" }, cost = self.costs.default },
      { upgrades = { "player_bleedout_timer_4" }, cost = self.costs.default },
      name_id = "menu_bleedout_timer_skill", desc_id = "menu_bleedout_timer_skill_desc", icon_xy = { 5, 2 }
    }
    self.skills.revive_swap_speed = {
      { upgrades = { "player_temp_swap_weapon_faster_1" }, cost = self.costs.default },
      { upgrades = { "player_temp_reload_weapon_faster_1" }, cost = self.costs.default },
      name_id = "menu_revive_swap_speed", desc_id = "menu_revive_swap_speed_desc", icon_xy = { 11, 3 }
    }
    self.skills.revive_move_speed = {
      { upgrades = { "player_temp_increased_movement_speed_1" }, cost = self.costs.default },
      name_id = "menu_running_from_death_beta", desc_id = "menu_running_from_death_beta_desc", icon_xy = { 11, 3 }
    }
    self.skills.swan_song = {
      { upgrades = { "temporary_berserker_damage_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "temporary_berserker_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_perseverance_beta", desc_id = "menu_perseverance_beta_desc", icon_xy = { 5, 12 }
    }
    self.skills.vengeful_swan = {
      { upgrades = { "player_berserker_no_ammo_cost" }, cost = self.costs.default },
      name_id = "menu_vengeful_swan", desc_id = "menu_vengeful_swan_desc", icon_xy = { 5, 12 }
    }
    self.skills.because_of_training = {
      { upgrades = { "player_melee_damage_dampener" }, cost = self.costs.default },
      { upgrades = { "player_counter_strike_melee" }, cost = self.costs.default },
      name_id = "menu_because_of_training", desc_id = "menu_because_of_training_desc", icon_xy = { 11, 7 }
    }
    self.skills.bloodthirst = {
      { upgrades = { "player_melee_damage_stacking_1" }, cost = self.costs.default },
      name_id = "menu_bloodthirst", desc_id = "menu_bloodthirst_desc", icon_xy = { 11, 6 }
    }
    self.skills.melee_reload_speed = {
      { upgrades = { "player_temp_melee_kill_increase_reload_speed_1" }, cost = self.costs.default },
      name_id = "menu_melee_reload_speed", desc_id = "menu_melee_reload_speed_desc", icon_xy = { 11, 6 }
    }
    self.skills.drop_soap = {
      { upgrades = { "player_counter_strike_spooc" }, cost = self.costs.default },
      name_id = "menu_drop_soap_beta", desc_id = "menu_drop_soap_beta_desc", icon_xy = { 4, 12 }
    }
    self.skills.berserker = {
      { upgrades = { "player_melee_damage_health_ratio_multiplier" }, cost = self.costs.default },
      name_id = "menu_wolverine_beta", desc_id = "menu_wolverine_beta_desc", icon_xy = { 2, 2 }
    }
    self.skills.gunserker = {
      { upgrades = { "player_damage_health_ratio_multiplier" }, cost = self.costs.default },
      name_id = "menu_gunserker", desc_id = "menu_gunserker_desc", icon_xy = { 2, 2 }
    }
    self.skills.frenzy = {
      { upgrades = { "player_healing_reduction_1", "player_health_damage_reduction_1", "player_max_health_reduction_1" }, cost = self.costs.default },
      { upgrades = { "player_health_damage_reduction_2", "player_max_health_reduction_2" }, cost = self.costs.default },
      name_id = "menu_frenzy", desc_id = "menu_frenzy_desc", icon_xy = { 11, 8 }
    }
    self.skills.perk_dmg = {
      { upgrades = { "weapon_passive_damage_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_passive_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_deckall_8", desc_id = "menu_perk_dmg", icon_xy = { 7, 11 }
    }
    self.skills.helmet_popping = {
      { upgrades = { "weapon_passive_headshot_damage_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_passive_headshot_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_deckall_2", desc_id = "menu_perk_headshot", icon_xy = { 6, 11 }
    }
    self.skills.muscle_health = {
      { upgrades = { "player_passive_health_multiplier_1", "player_bleed_out_health_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_passive_health_multiplier_2", "player_bleed_out_health_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "player_passive_health_multiplier_3", "player_bleed_out_health_multiplier_3" }, cost = self.costs.default },
      { upgrades = { "player_passive_health_multiplier_4", "player_bleed_out_health_multiplier_4", "player_passive_health_regen" }, cost = self.costs.default },
      name_id = "menu_deck2_1", desc_id = "menu_deck2_1_skill", icon_xy = { 1, 1 }
    }
    self.skills.muscle_panic = {
      { upgrades = { "player_panic_suppression", "player_uncover_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_killshot_close_panic_chance" }, cost = self.costs.default },
      name_id = "menu_deck2_7", desc_id = "menu_deck2_7_skill", icon_xy = { 7, 0 }
    }
    self.skills.armorer_perk = {
      { upgrades = { "player_tier_armor_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_tier_armor_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "player_tier_armor_multiplier_3" }, cost = self.costs.default },
      { upgrades = { "player_tier_armor_multiplier_4", "player_armor_grinding_1" }, cost = self.costs.default },
      name_id = "menu_bulletproof_name", desc_id = "menu_armorer_skill_desc", icon_xy = { 6, 4 }
    }
    self.skills.rogue_dodge = {
      { upgrades = { "player_passive_dodge_chance_1" }, cost = self.costs.default },
      { upgrades = { "player_passive_dodge_chance_2" }, cost = self.costs.default },
      { upgrades = { "player_passive_dodge_chance_3" }, cost = self.costs.default },
      { upgrades = { "player_dodge_ricochet_bullets" }, cost = self.costs.default },
      name_id = "menu_deck4_5", desc_id = "menu_deck4_5_skill", icon_xy = { 7, 3 }
    }
    self.skills.crook_skill = {
      { upgrades = { "player_level_2_dodge_addend_1", "player_level_2_armor_multiplier_1",
          "player_level_3_dodge_addend_1", "player_level_3_armor_multiplier_1",
          "player_level_4_dodge_addend_1", "player_level_4_armor_multiplier_1" },
        cost = self.costs.default
      },
      { upgrades = { "player_level_2_dodge_addend_2", "player_level_2_armor_multiplier_2",
          "player_level_3_dodge_addend_2", "player_level_3_armor_multiplier_2",
          "player_level_4_dodge_addend_2", "player_level_4_armor_multiplier_2" },
        cost = self.costs.default
      },
      { upgrades = { "player_level_2_dodge_addend_3", "player_level_2_armor_multiplier_3",
          "player_level_3_dodge_addend_3", "player_level_3_armor_multiplier_3",
          "player_level_4_dodge_addend_3", "player_level_4_armor_multiplier_3" },
        cost = self.costs.default
      },
      name_id = "menu_crook_skill", desc_id = "menu_crook_skill_desc", icon_xy = { 2, 12 }
    }
    self.skills.hitman_perk = {
      { upgrades = { "player_perk_armor_regen_timer_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_perk_armor_regen_timer_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "player_perk_armor_regen_timer_multiplier_3" }, cost = self.costs.default },
      { upgrades = { "player_passive_always_regen_armor_1" }, cost = self.costs.default },
      name_id = "menu_deck5_9", desc_id = "menu_hitman_skill_desc", icon_xy = { 2, 12 }
    }
    self.skills.burglar_stealth = {
      { upgrades = { "player_corpse_dispose_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_alarm_pager_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_pick_lock_speed_multiplier" }, cost = self.costs.default },
      name_id = "menu_deck7_3", desc_id = "menu_burglar_stealth", icon_xy = { 3, 12 }
    }
    self.skills.ex_pres = {
      { upgrades = { "player_armor_health_store_amount_1" }, cost = self.costs.default },
      { upgrades = { "player_armor_health_store_amount_2" }, cost = self.costs.default },
      { upgrades = { "player_armor_health_store_amount_3", "player_armor_max_health_store_multiplier" }, cost = self.costs.default },
      name_id = "menu_deck13_1", desc_id = "menu_break_skill", icon_xy = { 0, 0 }
    }
    self.skills.yakuza_speed = {
      { upgrades = { "player_movement_speed_damage_health_ratio_multiplier", "player_movement_speed_damage_health_ratio_threshold_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_armor_regen_damage_health_ratio_multiplier_1", "player_armor_regen_damage_health_ratio_threshold_multiplier" }, cost = self.costs.default },
      name_id = "menu_yakuza_speed", desc_id = "menu_yakuza_speed_desc", icon_xy = { 0, 0 }
    }
    self.skills.maniac_base = {
      { upgrades = { "player_cocaine_stacking_1", "player_sync_cocaine_stacks" }, cost = self.costs.default },
      { upgrades = { "player_sync_cocaine_upgrade_level_1" }, cost = self.costs.default },
      { upgrades = { "player_cocaine_stack_absorption_multiplier_1" }, cost = self.costs.default },
      name_id = "menu_deck14_9", desc_id = "menu_deck14_1_skill", icon_xy = { 0, 0 }
    }
    self.skills.kingpin_base = {
      { upgrades = { "temporary_chico_injector_2" }, cost = self.costs.default },
      { upgrades = { "temporary_chico_injector_3" }, cost = self.costs.default },
      name_id = "menu_deck17_3", desc_id = "menu_kingpin_base", icon_xy = { 0, 0 }
    }
    self.skills.kingpin_prio = {
      { upgrades = { "player_chico_preferred_target" }, cost = self.costs.default },
      name_id = "menu_deck17_5", desc_id = "menu_kingpin_priority", icon_xy = { 0, 0 }
    }
    self.skills.kingpin_healing = {
      { upgrades = { "player_chico_injector_low_health_multiplier" }, cost = self.costs.default },
      name_id = "menu_deck17_7", desc_id = "menu_kingpin_healing", icon_xy = { 0, 0 }
    }
    self.skills.kingpin_cooldown = {
      { upgrades = { "player_chico_injector_health_to_speed" }, cost = self.costs.default },
      name_id = "menu_deck17_9", desc_id = "menu_kingpin_cooldown", icon_xy = { 0, 0 }
    }
    self.skills.stoic_base = {
      { upgrades = { "damage_control", "player_damage_control_passive", "player_damage_control_cooldown_drain_1" }, cost = self.costs.default },
      { upgrades = { "player_damage_control_cooldown_drain_2" }, cost = self.costs.default },
      name_id = "menu_deck19_1", desc_id = "menu_stoic_skill", icon_xy = { 0, 0 }
    }
    self.skills.stoic_negation = {
      { upgrades = { "player_damage_control_auto_shrug" }, cost = self.costs.default },
      name_id = "menu_deck19_5", desc_id = "menu_stoic_negation", icon_xy = { 0, 0 }
    }
    self.skills.stoic_regen = {
      { upgrades = { "player_armor_to_health_conversion" }, cost = self.costs.default },
      { upgrades = { "player_damage_control_healing" }, cost = self.costs.default },
      name_id = "menu_deck19_9", desc_id = "menu_stoic_regen", icon_xy = { 0, 0 }
    }
    self.skills.sicario_stack = {
      { upgrades = { "player_dodge_shot_gain" }, cost = self.costs.default },
      name_id = "menu_deck18_3", desc_id = "menu_sicario_stack_desc", icon_xy = { 0, 0 }
    }
    self.skills.infil_melee = {
      { upgrades = { "melee_stacking_hit_damage_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "melee_stacking_hit_damage_multiplier_2", "melee_stacking_hit_expire_t" }, cost = self.costs.default },
      name_id = "menu_infil_melee", desc_id = "menu_infil_melee_desc", icon_xy = { 0, 0 }
    }
    self.skills.infil_heal = {
      { upgrades = { "player_melee_life_leech" }, cost = self.costs.default },
      { upgrades = { "player_melee_kill_life_leech" }, cost = self.costs.default },
      name_id = "menu_deck8_9", desc_id = "menu_infil_heal_desc", icon_xy = { 0, 0 }
    }
    self.skills.gambler_heal = {
      { upgrades = { "temporary_loose_ammo_restore_health_1", "player_loose_ammo_restore_health_give_team" }, cost = self.costs.default },
      { upgrades = { "temporary_loose_ammo_restore_health_2" }, cost = self.costs.default },
      { upgrades = { "temporary_loose_ammo_restore_health_3" }, cost = self.costs.default },
      name_id = "menu_deck10_1", desc_id = "menu_gambler_heal", icon_xy = { 0, 0 }
    }
    self.skills.gambler_mag_throw = {
      { upgrades = { "temporary_loose_ammo_give_team" }, cost = self.costs.default },
      name_id = "menu_mag_throw", desc_id = "menu_mag_throw_desc", icon_xy = { 8, 3 }
    }
    self.skills.biker_perk = {
      { upgrades = { "player_wild_health_amount_1" }, cost = self.costs.default },
      { upgrades = { "player_less_health_wild_cooldown_1" }, cost = self.costs.default },
      { upgrades = { "player_less_armor_wild_health_1" }, cost = self.costs.default },
      { upgrades = { "player_less_armor_wild_cooldown_1" }, cost = self.costs.default },
      name_id = "menu_deck16_1", desc_id = "menu_biker_perk", icon_xy = { 0, 0 }
    }
    self.skills.anarch_rise = {
      { upgrades = { "player_armor_increase_1", "player_health_decrease_1" }, cost = self.costs.default },
      { upgrades = { "player_armor_increase_2", "player_health_decrease_2" }, cost = self.costs.default },
      { upgrades = { "player_armor_increase_3", "player_health_decrease_3" }, cost = self.costs.default },
      name_id = "menu_deck15_7", desc_id = "menu_anarch_rise", icon_xy = { 11, 8 }
    }
    self.skills.h3h3_cooldown = {
      { upgrades = { "player_tag_team_cooldown_drain_2" }, cost = self.costs.default },
      name_id = "menu_deck20_9", desc_id = "menu_h3h3_cooldown", icon_xy = { 0, 0 }
    }
    self.skills.h3h3_absorb = {
      { upgrades = { "player_tag_team_damage_absorption" }, cost = self.costs.default },
      name_id = "menu_deck20_5", desc_id = "menu_h3h3_absorb", icon_xy = { 0, 0 }
    }
    self.skills.leech_swan = {
      { upgrades = { "player_copr_out_of_health_move_slow_1" }, cost = self.costs.default },
      { upgrades = { "player_activate_ability_downed" }, cost = self.costs.default },
      name_id = "menu_deck22_1", desc_id = "menu_leech_swan", icon_xy = { 0, 0 }
    }
    self.skills.leech_duration = {
      { upgrades = { "player_copr_speed_up_on_kill_1" }, cost = self.costs.default },
      { upgrades = { "temporary_copr_ability_2" }, cost = self.costs.default },
      name_id = "menu_deck22_5", desc_id = "menu_leech_duration", icon_xy = { 0, 0 }
    }
    self.skills.leech_healing = {
      { upgrades = { "player_copr_teammate_heal_2" }, cost = self.costs.default },
      { upgrades = { "player_copr_activate_bonus_health_ratio_1" }, cost = self.costs.default },
      name_id = "menu_deck22_3", desc_id = "menu_leech_healing", icon_xy = { 0, 0 }
    }
    self.skills.leech_segments = {
      { upgrades = { "player_copr_static_damage_ratio_2", "player_copr_kill_life_leech_2" }, cost = self.costs.default },
      name_id = "menu_deck22_9", desc_id = "menu_leech_segments", icon_xy = { 0, 0 }
    }
    self.skills.copycat_ricochet = {
      { upgrades = { "player_dodge_ricochet_bullets" }, cost = self.costs.default },
      name_id = "menu_ricochet", desc_id = "menu_ricochet_skill", icon_xy = { 0, 0 }
    }
    self.skills.copycat_reload = {
      { upgrades = { "player_primary_reload_secondary_1", "player_secondary_reload_primary_1" }, cost = self.costs.default },
      { upgrades = { "weapon_mrwi_primary_reload_swap_secondary_1", "weapon_mrwi_secondary_reload_swap_primary_1" }, cost = self.costs.default },
      name_id = "menu_tac_reload", desc_id = "menu_tac_reload_desc", icon_xy = { 0, 9 }
    }
    self.skills.oldholm_syndrome = {
      { upgrades = { "player_civilian_reviver" }, cost = self.costs.default },
      { upgrades = { "player_civilian_gives_ammo" }, cost = self.costs.default },
      name_id = "menu_oldholm_syndrome", desc_id = "menu_oldholm_syndrome_desc", icon_xy = { 3, 8 }
    }
    self.skills.tough_guy = {
      { upgrades = { "player_damage_shake_multiplier" }, cost = self.costs.default },
      name_id = "menu_tough_guy", desc_id = "menu_tough_guy_desc", icon_xy = { 1, 1 }
    }
    self.skills.hip_accuracy = {
      { upgrades = { "saw_hip_fire_spread_multiplier", "pistol_hip_fire_spread_multiplier",
          "assault_rifle_hip_fire_spread_multiplier", "lmg_hip_fire_spread_multiplier",
          "snp_hip_fire_spread_multiplier", "smg_hip_fire_spread_multiplier",
          "shotgun_hip_fire_spread_multiplier" }, cost = self.costs.default },
      name_id = "menu_hip_accuracy", desc_id = "menu_hip_accuracy_desc", icon_xy = { 7, 10 }
    }
    self.skills.mag_plus = {
      { upgrades = { "weapon_clip_ammo_increase_1" }, cost = self.costs.default },
      { upgrades = { "weapon_clip_ammo_increase_2" }, cost = self.costs.default },
      name_id = "menu_mag_plus", desc_id = "menu_mag_plus_desc", icon_xy = { 2, 0 }
    }
    self.skills.smg_rof = {
      { upgrades = { "smg_fire_rate_multiplier" }, cost = self.costs.default },
      name_id = "menu_smg_rof", desc_id = "menu_smg_rof_desc", icon_xy = { 3, 3 }
    }
    self.skills.custody_timer = {
      { upgrades = { "player_respawn_time_multiplier" }, cost = self.costs.default },
      name_id = "menu_custody_timer", desc_id = "menu_custody_timer_desc", icon_xy = { 4, 8 }
    }
    self.skills.crouch_dodge = {
      { upgrades = { "player_crouch_dodge_chance_1" }, cost = self.costs.default },
      { upgrades = { "player_crouch_dodge_chance_2" }, cost = self.costs.default },
      name_id = "menu_crouch_dodge", desc_id = "menu_crouch_dodge_desc", icon_xy = { 0, 11 }
    }
    self.skills.dominator = {
      { upgrades = { "player_intimidation_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_assault_intimidate" }, cost = self.costs.default },
      name_id = "menu_dominator", desc_id = "menu_dominator_desc", icon_xy = { 2, 8 }
    }
    self.skills.threat_inc = {
      { upgrades = { "player_passive_suppression_bonus_1" }, cost = self.costs.default },
      { upgrades = { "player_passive_suppression_bonus_2" }, cost = self.costs.default },
      { upgrades = { "player_suppression_bonus" }, cost = self.costs.default },
      name_id = "menu_oppressor_name", desc_id = "menu_oppressor_desc", icon_xy = { 7, 0 }
    }
    self.skills.daredevil = {
      { upgrades = { "player_climb_speed_multiplier_1" }, cost = self.costs.default },
      { upgrades = { "player_climb_speed_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_daredevil", desc_id = "menu_daredevil_desc", icon_xy = { 5, 10 }
    }
    self.skills.downed_ads = {
      { upgrades = { "player_primary_weapon_when_downed" }, cost = self.costs.default },
      { upgrades = { "player_steelsight_when_downed" }, cost = self.costs.default },
      name_id = "menu_downed_ads", desc_id = "menu_downed_ads_desc", icon_xy = { 1, 2 }
    }
    self.skills.drop_cloth = {
      { upgrades = { "player_silent_kill" }, cost = self.costs.default },
      name_id = "menu_drop_cloth", desc_id = "menu_drop_cloth_desc", icon_xy = { 0, 0 }
    }
    self.skills.tinkerer = {
      { upgrades = { "weapon_modded_recoil_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_modded_spread_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_modded_damage_multiplier" }, cost = self.costs.default },
      name_id = "menu_tinkerer", desc_id = "menu_tinkerer_desc", icon_xy = { 1, 7 }
    }
    self.skills.illegal_parts = {
      { upgrades = { "weapon_fire_rate_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_fire_rate_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_illegal_parts", desc_id = "menu_illegal_parts_desc", icon_xy = { 10, 2 }
    }
    self.skills.accuracy_increase = {
      { upgrades = { "player_weapon_accuracy_increase_1" }, cost = self.costs.default },
      { upgrades = { "player_weapon_accuracy_increase_2" }, cost = self.costs.default },
      name_id = "menu_ar_stability", desc_id = "menu_ar_stability_desc", icon_xy = { 8, 5 }
    }
    self.skills.stability_increase = {
      { upgrades = { "player_stability_increase_bonus_1" }, cost = self.costs.default },
      { upgrades = { "player_stability_increase_bonus_2" }, cost = self.costs.default },
      name_id = "menu_lmg_stability", desc_id = "menu_lmg_stability_desc", icon_xy = { 8, 5 }
    }
    self.skills.reload_speed = {
      { upgrades = { "weapon_passive_reload_speed_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_passive_reload_speed_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "weapon_passive_reload_speed_multiplier_3" }, cost = self.costs.default },
      name_id = "menu_reload_speed", desc_id = "menu_reload_speed_desc", icon_xy = { 1, 9 }
    }
    self.skills.silencer_statboost = {
      { upgrades = { "weapon_silencer_recoil_multiplier" }, cost = self.costs.default },
      { upgrades = { "weapon_silencer_spread_multiplier" }, cost = self.costs.default },
      name_id = "menu_silencer_statboost", desc_id = "menu_silencer_statboost_desc", icon_xy = { 4, 4 }
    }
    self.skills.hollow_point = {
      { upgrades = { "weapon_passive_armor_piercing_chance" }, cost = self.costs.default },
      { upgrades = { "player_ap_bullets_1" }, cost = self.costs.default },
      name_id = "menu_hollow_point", desc_id = "menu_hollow_point_desc", icon_xy = { 11, 9 }
    }
    self.skills.loud_and_proud = {
      { upgrades = { "player_detection_risk_damage_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_detection_risk_damage_multiplier_2" }, cost = self.costs.default },
      name_id = "menu_loud_and_proud", desc_id = "menu_loud_and_proud_desc", icon_xy = { 0, 0 }
    }
    self.skills.pager_snatch = {
      { upgrades = { "player_melee_kill_snatch_pager_chance" }, cost = self.costs.default },
      { upgrades = { "player_melee_kill_snatch_pager_chance_2" }, cost = self.costs.default },
      { upgrades = { "player_melee_kill_snatch_pager_chance_3" }, cost = self.costs.default },
      { upgrades = { "player_melee_kill_snatch_pager_chance_4" }, cost = self.costs.default },
      name_id = "menu_pager_snatch", desc_id = "menu_pager_snatch_desc", icon_xy = { 0, 0 }
    }
    self.skills.blanks = {
      { upgrades = { "player_civ_harmless_bullets" }, cost = self.costs.default },
      name_id = "menu_blanks", desc_id = "menu_blanks_desc", icon_xy = { 6, 7 }
    }
    self.skills.shell_dimension = {
      { upgrades = { "shotgun_consume_no_ammo_chance_1", "pistol_consume_no_ammo_chance_1", "assault_rifle_consume_no_ammo_chance_1",
          "snp_consume_no_ammo_chance_1", "smg_consume_no_ammo_chance_1", "lmg_consume_no_ammo_chance_1", "minigun_consume_no_ammo_chance_1" }, cost = self.costs.default },
      { upgrades = { "shotgun_consume_no_ammo_chance_2", "pistol_consume_no_ammo_chance_2", "assault_rifle_consume_no_ammo_chance_2",
          "snp_consume_no_ammo_chance_2", "smg_consume_no_ammo_chance_2", "lmg_consume_no_ammo_chance_2", "minigun_consume_no_ammo_chance_2" }, cost = self.costs.default },
      name_id = "menu_shell_dimension", desc_id = "menu_shell_dimension_desc", icon_xy = { 5, 0 }
    }
    self.skills.sharp_damage = {
      { upgrades = { "player_melee_sharp_damage_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_melee_sharp_damage_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "player_melee_sharp_damage_multiplier_3" }, cost = self.costs.default },
      name_id = "menu_sharp_damage", desc_id = "menu_sharp_damage_desc", icon_xy = { 4, 10 }
    }
    self.skills.hypocritical = {
      { upgrades = { "player_critical_hit_chance_1" }, cost = self.costs.default },
      { upgrades = { "player_critical_hit_chance_2" }, cost = self.costs.default },
      name_id = "menu_hypocritical", desc_id = "menu_hypocritical_desc", icon_xy = { 6, 11 }
    }
    self.skills.nebula_plus = {
      { upgrades = { "player_assets_cost_multiplier" }, cost = self.costs.default },
      { upgrades = { "player_assets_cost_multiplier_2" }, cost = self.costs.default },
      { upgrades = { "player_assets_cost_multiplier_3" }, cost = self.costs.default },
      name_id = "menu_nebula_plus", desc_id = "menu_nebula_plus_desc", icon_xy = { 0, 8 }
    }
  end)