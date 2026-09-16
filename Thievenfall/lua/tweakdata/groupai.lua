-- Unit replacements & new definitions
Hooks:PostHook(GroupAITweakData, "_init_unit_categories", "CrimDusk_InitGroupAIT", function(self, difficulty)
  -- Pistol/M4 HRT is Pistol/MP5 instead
  self.unit_categories.FBI_suit_C45_M4.unit_types = {
    america = {
      Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
      Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
    },
    russia = {
      Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg"),
      Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg")
    },
    zombie = {
      Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_1/ene_fbi_hvh_1"),
      Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3")
    },
    murkywater = {
      Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
      Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
    },
    federales = {
      Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
      Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
    }
  }

  -- Russian M4/MP5 HRT uses AK/VAL instead of VAL/VAL
  self.unit_categories.FBI_suit_M4_MP5.unit_types.russia = {
    Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_ak47_ass/ene_akan_cs_cop_ak47_ass"),
    Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_asval_smg/ene_akan_cs_cop_asval_smg")
  }

  if difficulty >= 3 then -- Hard
    -- Dozers
    local unit_types = {
      america = {
        Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"),
        Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"),
        Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
        Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
      },
      russia = {
        Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"),
        Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"),
        Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
        Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg")
      },
      zombie = {
        Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"),
        Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"),
        Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
        Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3")
      },
      murkywater = {
        Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_1/ene_murkywater_bulldozer_1"),
        Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_2/ene_murkywater_bulldozer_2"),
        Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_medic/ene_murkywater_bulldozer_medic"),
        Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_3/ene_murkywater_bulldozer_3")
      },
      federales = {
        Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"),
        Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"),
        Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale"),
        Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249")
      }
    }

    for _, data in pairs(unit_types) do
      for i = 4, difficulty - 1, -1 do table.remove(data, i) end
    end

    self.unit_categories.FBI_tank.unit_types = unit_types
  end

  if difficulty >= 7 then -- Death Wish
    -- Winters Shields replace shields
    local WintersShield = deep_clone(self.unit_categories.Phalanx_minion)
    WintersShield.is_captain = nil

    self.unit_categories.CS_shield = WintersShield
    self.unit_categories.FBI_shield = WintersShield
  end

  if difficulty == 8 then -- Death Sentence
    -- Minigun dozers
    self.unit_categories.FBI_tank.unit_types.america = {
      Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"),
      Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"),
      Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"),
      Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"),
      Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun")
    }
    table.insert(self.unit_categories.FBI_tank.unit_types.russia, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
    table.insert(self.unit_categories.FBI_tank.unit_types.zombie, Idstring("units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"))
    table.insert(self.unit_categories.FBI_tank.unit_types.murkywater, Idstring("units/pd2_dlc_bph/characters/ene_murkywater_bulldozer_4/ene_murkywater_bulldozer_4"))
    table.insert(self.unit_categories.FBI_tank.unit_types.federales, Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"))
  end
end)

-- New spawn groups
Hooks:PostHook(GroupAITweakData, "_init_enemy_spawn_groups", "CrimDusk_InitGroupAISpawnGroups", function(self, difficulty)
  self.enemy_spawn_groups.fbi_hrt = {
    amount = { 4, 5 },
    spawn = {
      {
        unit = "FBI_suit_M4_MP5",
        amount_min = 2, amount_max = 2,
        freq = 1, rank = 3,
        tactics = self._tactics.swat_rifle
      },
      {
        unit = "FBI_suit_C45_M4",
        amount_min = 1, amount_max = 2,
        freq = 1, rank = 2,
        tactics = self._tactics.swat_shotgun_flank
      },
      {
        unit = "FBI_suit_stealth_MP5",
        amount_min = 1, amount_max = 1,
        freq = 1, rank = 1,
        tactics = self._tactics.swat_rifle_flank
      }
    }
  }
end)

Hooks:PostHook(GroupAITweakData, "_init_task_data", "CrimDusk_InitGroupAITaskData", function(self, difficulty)
  -- Flashbang adjustments
  local FlashbangTimer = { 5, 4.5, 4, 3.5, 3, 2.5, 2 }
  local FlashbangRange = { 1000, 950, 900, 850, 800, 750, 700 }

  self.flash_grenade.timer = FlashbangTimer[difficulty - 1]
  self.flash_shields.marshal_shield.flash_charge_timer = self.flash_grenade.timer

  self.flash_grenade.range = FlashbangRange[difficulty - 1]
  self.flash_shields.marshal_shield.flash_range = self.flash_grenade.range

  -- Assault parameters
  self.besiege.assault.sustain_duration_min = { 30, 90, 120 }
  self.besiege.assault.sustain_duration_max = { 60, 120, 180 }
  self.besiege.assault.sustain_duration_balance_mul = { 1, 1.2, 1.4, 1.6 }

  self.besiege.assault.force = { 10, 12, 14 }
  self.besiege.assault.force_pool = { 50, 100, 100 }
  self.besiege.assault.delay = { 60, 60, 30 }
  self.besiege.assault.hostage_hesitation_delay = { 15, 10, 5 }

  self.besiege.assault.force_balance_mul = { 1, 2, 3, 4 }
  self.besiege.assault.force_pool_balance_mul = { 1, 2, 3, 4 }

  -- Winters rework
  if difficulty >= 6 then self.phalanx.spawn_chance = { start = 0, increase = 0.25, max = 1, decrease = 1, respawn_delay = 120 }
  else self.phalanx.spawn_chance = { start = 0, increase = 0, max = 0, decrease = 0, respawn_delay = 120 } end
  self.phalanx.vip.damage_reduction = { start = 0, increase = 0, max = 0, increase_intervall = 5 }

  -- Re-add HRT to assault breaks
  self.besiege.recon.groups = {
    fbi_hrt = { 1, 1, 1 },
    single_spooc = { 0, 0, 0 },
    Phalanx = { 0, 0, 0 },
    marshal_squad = { 0, 0, 0 }
  } -- is this actually working???

  -- Re-enable reinforcement groups
  self.besiege.reenforce.groups = {
    tac_swat_shotgun_rush = { 0.5, 0.25, 0.1 },
    tac_swat_shotgun_flank = { 0.25, 0.1, 0.05 },
    tac_swat_rifle = { 0.5, 0.25, 0.1 },
    tac_swat_rifle_flank = { 0.25, 0.1, 0.05 }
  }
end)