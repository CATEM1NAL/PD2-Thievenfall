Hooks:PreHook(MoneyTweakData, "init", "CrimDusk_PreMoneyTweakInit", function(self, tweak_data)
  if Global.game_settings and Global.game_settings.difficulty and CrimDusk.DiffScale() ~= tweak_data:difficulty_to_index(Global.game_settings.difficulty) then return end
end)

Hooks:PostHook(MoneyTweakData, "init", "CrimDusk_MoneyTweakInit", function(self, tweak_data)
  local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
  local DiffIndex = tweak_data:difficulty_to_index(difficulty)
  local SafehouseMult = Global.CrimDusk.money_multiplier or 1

  self.weapon_cost = 0
  self.sell_weapon_multiplier = 0
  self.sell_mask_multiplier = 0

  self.level_limit.low_cap_multiplier = 1
  self.level_limit.pc_difference_multipliers = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }

  self.difficulty_multiplier_payout = { 10, 10.5, 11, 11.5, 12, 12.5, 15 }

  self.mission_asset_cost_small = self._create_value_table(100000, 250000, 10, true, 1)
  self.mission_asset_cost_medium = self._create_value_table(200000, 750000, 10, true, 1)
  self.mission_asset_cost_large = self._create_value_table(1000000, 5000000, 10, true, 1)

  self.mission_asset_cost_multiplier_by_risk = { 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5 }
  self.preplaning_asset_cost_multiplier_by_risk = { 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5 }

  self.preplaning_asset_cost_thermite = 500000
  self.preplaning_asset_cost_escapebig = 250000
  self.preplaning_asset_cost_spycam = 50000
  self.preplaning_asset_cost_delay10 = 100000
  self.preplaning_asset_cost_delay20 = 200000
  self.preplaning_asset_cost_delay30 = 300000
  self.preplaning_asset_cost_timelock60 = 300000
  self.preplaning_asset_cost_cake = 50000
  self.preplaning_asset_cost_extracameras = 10000
  self.preplaning_asset_cost_accesscameras = 20000
  self.preplaning_asset_cost_drillparts = 100000
  self.preplaning_asset_cost_deaddropbag = 150000
  self.preplaning_asset_cost_unlocked_door = 50000
  self.preplaning_asset_cost_unlocked_window = 50000
  self.preplaning_asset_cost_zipline = 100000
  self.preplaning_asset_cost_highlight_keybox = 50000
  self.preplaning_asset_cost_keycard = 75000
  self.preplaning_asset_cost_disable_alarm_button = 50000
  self.preplaning_asset_cost_safe_escape = 400000
  self.preplaning_asset_cost_sniper_spot = 100000
  self.preplaning_asset_cost_framing_frame_1_truck = 50000
  self.preplaning_asset_cost_framing_frame_1_entry_point = 50000
  self.preplaning_asset_cost_bag_shortcut = 50000
  self.preplaning_asset_cost_bag_zipline = 100000
  self.preplaning_asset_cost_loot_drop_off = 100000
  self.preplaning_asset_cost_thermal_paste = 50000
  self.preplaning_asset_cost_branchbank_vault_key = 200000
  self.preplaning_mia_cost_sniper = 150000
  self.preplaning_mia_cost_delayed_police = 300000
  self.preplaning_mia_cost_reduce_mobsters = 100000
  self.preplaning_asset_cost_glass_cutter = 20000
  self.preplaning_thebomb_cost_spotter = 50000
  self.preplaning_thebomb_cost_crowbar = 20000
  self.preplaning_thebomb_cost_ladder = 10000
  self.preplaning_thebomb_cost_hacker = 100000
  self.preplaning_thebomb_cost_manifest = 25000
  self.preplaning_thebomb_cost_pilot = 100000
  self.preplaning_thebomb_cost_escape_mid = 200000
  self.preplaning_thebomb_cost_escape_close = 400000
  self.preplaning_thebomb_cost_demolition = 50000
  self.preplaning_asset_cost_roof_access = 100000
  self.preplaning_asset_cost_upper_floor_access = 100000
  self.preplaning_asset_cost_crowbar_single = 20000
  self.preplaning_asset_cost_mex_keys = 20000
  self.preplanning_asset_cost_bex_car_pull = 100000
  self.preplanning_asset_cost_bex_drunk_mariachi = 50000
  self.preplanning_asset_cost_bex_garbage_truck = 50000
  self.preplanning_asset_cost_bex_zipline = 80000
  self.preplanning_asset_cost_pex_parked_car = 20000
  self.preplanning_asset_cost_pex_spiked_churro = 20000
  self.preplanning_asset_cost_pex_camera_access = 20000
  self.preplanning_asset_cost_pex_open_window = 20000
  self.preplanning_asset_cost_fex_stealth_entry_with_boat = 20000
  self.preplanning_asset_cost_fex_loud_escape_with_heli = 20000
  self.preplanning_asset_cost_fex_stealth_semi_open_garage_door = 20000
  self.preplanning_asset_cost_kenaz_zeppelin_escape = 250000
  self.preplanning_asset_cost_kenaz_van_escape = 300000
  self.preplanning_asset_cost_kenaz_loud_entry_with_c4 = 50000
  self.preplanning_asset_cost_kenaz_drill_better_plasma_cutter = 50000
  self.preplanning_asset_cost_kenaz_drill_improved_cooling_system = 50000
  self.preplanning_asset_cost_kenaz_drill_engine_optimization = 100000
  self.preplanning_asset_cost_kenaz_drill_engine_additional_power = 200000
  self.preplanning_asset_cost_kenaz_drill_extra_battery = 100000
  self.preplanning_asset_cost_kenaz_drill_water_level_indicator = 0
  self.preplanning_asset_cost_kenaz_drill_timer_addon = 0
  self.preplanning_asset_cost_kenaz_drill_toolbox = 50000
  self.preplanning_asset_cost_kenaz_drill_medkit = 150000
  self.preplanning_asset_cost_kenaz_drill_ammobox = 150000
  self.preplanning_asset_cost_kenaz_ace_pilot = 50000
  self.preplanning_asset_cost_kenaz_faster_blimp = 50000
  self.preplanning_asset_cost_kenaz_sabotage_skylight_barrier = 50000
  self.preplanning_asset_cost_kenaz_unlocked_cages = 100000
  self.preplanning_asset_cost_kenaz_unlocked_doors = 50000
  self.preplanning_asset_cost_kenaz_guitar_case_position = 0
  self.preplanning_asset_cost_kenaz_disable_metal_detectors = 0
  self.preplanning_asset_cost_kenaz_celebrity_visit = 50000
  self.preplanning_asset_cost_kenaz_vault_gate_key = 50000
  self.preplanning_asset_cost_chas_tram = 100000

  local LooseCash = {
    -- Generic
    money_bundle = 500, gen_atm = 12500, slot_machine_payout = 12500,
    vault_loot_gold = 1250, vault_loot_cash = 7500, vault_loot_coins = 500,
    vault_loot_ring = 250, vault_loot_jewels = 250,

    diamondheist_vault_bust = 125, -- Necklaces
    diamondheist_vault_diamond = 125, -- Jewelry
    diamondheist_big_diamond = 250, -- Tiara?

    ring_band = 125, -- One Ring

    -- Big Bank
    vault_loot_chest = 125, vault_loot_diamond_chest = 250, vault_loot_banknotes = 125,
    vault_loot_silver = 125, vault_loot_diamond_collection = 375, vault_loot_trophy = 25,
    spawn_bucket_of_money = 12500
  }
  for loot, value in pairs(LooseCash) do self.small_loot[loot] = math.floor(value * DiffIndex * 0.5 * SafehouseMult) end
  for loot, value in pairs(self.bag_values) do self.bag_values[loot] = self.bag_values[loot] * SafehouseMult end
end)