Hooks:PostHook(InfamyTweakData, "init", "CrimDusk_InfamyTweakInit", function(self)
  local cost_old = Application:digest_value(200000000, true)

  -- 52 infamies, every infamy costs $200m offshore
  self.ranks = 52
  self.offshore_cost = { cost_old, cost_old, cost_old, cost_old, cost_old, cost_old }
  self.icon_rank_step = 13

  -- New infamy reward structure
  self.tree = {
    -- 1 to 5
    "infamy_suitpack_t800", "infamy_root", "infamy_color_inf_02", "infamy_color_inf_03", "infamy_mastermind",
    -- 6 to 10
    "infamy_glovepack_molten", "infamy_color_inf_05", "infamy_enforcer", "infamy_color_inf_06", "infamy_color_inf_07",
    -- 11 to 15
    "infamy_technician", "infamy_glovepack_tiger", "in31_suitpack_leather", "infamy_ghost", "infamy_color_inf_10",
    -- 16 to 20
    "infamy_color_inf_11", "infamy_maskpack_balaclava", "infamy_glovepack_cosmos", "infamy_color_inf_13", "infamy_maskpack_lurker",
    -- 21 to 25
    "infamy_color_inf_14", "infamy_color_inf_15", "infamy_maskpack_daft", "infamy_glovepack_neoncity", "in31_weapon_color_stinger_01",
    -- 26 to 30
    "in32_suitpack_gangstercoat", "infamy_maskpack_punk", "in31_weapon_color_stinger_02", "in31_weapon_color_stinger_03", "infamy_maskpack_pain",
    -- 31 to 35
    "in31_glovepack_wool", "in31_weapon_color_stinger_05", "infamy_maskpack_ranger", "in31_weapon_color_stinger_06", "in31_weapon_color_stinger_07",
    -- 36 to 40
    "infamy_maskpack_hood", "in31_glovepack_silver", "in32_weapon_color_stinger_01", "in32_suitpack_general_default_blue", "infamy_maskpack_destroyer",
    -- 41 to 45
    "in32_weapon_color_stinger_02", "in32_weapon_color_stinger_03", "in31_maskpack_lastlaugh", "in32_glovepack_goldnet", "in32_weapon_color_stinger_05",
    -- 46 to 50
    "in31_maskpack_cyberpunk", "in32_weapon_color_stinger_06", "in32_weapon_color_stinger_07", "in32_maskpack_goldenbrute", "in32_weapon_color_stinger_08",
    -- 50 to 52
    "in32_maskpack_ingoldnito", "in33_one_hundred"
  }

  -- Infamy 1
  self.items.infamy_suitpack_t800.desc_params = { xpboost = "5%" }
  self.items.infamy_suitpack_t800.upgrades = {
    { nil, "player_styles", "t800", "default" },
    { nil, "player_styles", "t800", "toughboy" },
    { nil, "player_styles", "t800", "red" },
    { nil, "player_styles", "t800", "cowboy" },
    { nil, "weapon_skins", "color_inf_01" },
    join_stingers = { 1, 2 },
    infamous_lootdrop = 2,
    infamous_xp = 1.05
  }

  -- Infamy 2
  self.items.infamy_root.upgrades = {
    { nil, "masks", "aviator" },
    infamous_xp = 1.05
  }

  -- Need to combine rewards for them to fit within 52 levels
  local CombinedRewards = {
    -- Stingers
    infamy_stinger_003 = "infamy_color_inf_02",
    infamy_stinger_004 = "infamy_color_inf_03",
    infamy_stinger_005 = "infamy_glovepack_molten",
    infamy_stinger_006 = "infamy_color_inf_05",
    infamy_stinger_007 = "infamy_color_inf_06",
    infamy_stinger_008 = "infamy_color_inf_07",
    infamy_stinger_009 = "infamy_glovepack_tiger",
    infamy_stinger_010 = "in31_suitpack_leather",
    infamy_stinger_011 = "infamy_color_inf_10",
    infamy_stinger_012 = "infamy_color_inf_11",
    infamy_stinger_013 = "infamy_glovepack_cosmos",
    infamy_stinger_014 = "infamy_color_inf_13",
    infamy_stinger_015 = "infamy_color_inf_14",
    infamy_stinger_016 = "infamy_color_inf_15",
    infamy_stinger_017 = "infamy_glovepack_neoncity",

    -- Suit variants
    in31_suitpack_leather_black = "in31_suitpack_leather",
    in31_suitpack_leather_red = "in31_suitpack_leather",
    in31_suitpack_leather_white = "in31_suitpack_leather",
    in32_suitpack_gangstercoat_irish = "in32_suitpack_gangstercoat",
    in32_suitpack_gangstercoat_british = "in32_suitpack_gangstercoat",
    in32_suitpack_gangstercoat_french = "in32_suitpack_gangstercoat",
    in32_suitglovepack_general_postmoto = "in32_suitpack_general_default_blue",

    -- Weapon colours
    infamy_color_inf_04 = "infamy_glovepack_molten",
    infamy_color_inf_08 = "infamy_glovepack_tiger",
    infamy_color_inf_09 = "in31_suitpack_leather",
    infamy_color_inf_12 = "infamy_glovepack_cosmos",
    infamy_color_inf_16 = "infamy_glovepack_neoncity",
    in31_weapon_color_stinger_04 = "in31_glovepack_wool",
    in31_weapon_color_stinger_08 = "in31_glovepack_silver",
    in32_weapon_color_stinger_04 = "in32_glovepack_goldnet",
    in32_weapon_color_stinger_09 = "in32_maskpack_ingoldnito"
  }

  for reward, target in pairs(CombinedRewards) do
    for i, upgrade in pairs(self.items[reward].upgrades) do
      self.items[target].upgrades[i] = upgrade
    end
  end

end)