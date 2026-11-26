local FileIdent = "NarrativeTweakData"

Hooks:PostHook(NarrativeTweakData, "init", "CrimDusk_NarrativeTweakInit", function(self, tweak_data)
  -- Licensed heists are always accessible, because it's not the player's fault for buying the game after 2024.
  self.jobs.dark.dlc = nil
  self.jobs.mad.dlc = nil

  -- Tutorials
  self.jobs.cd_tut1 = deep_clone(self.jobs.short1)
  self.jobs.cd_tut1.name_id = "heist_short1_stage1_hl"
  self.jobs.cd_tut1.briefing_id = "heist_short1_stage1_briefing"
  self.jobs.cd_tut1.chain = { self.stages.short_1_1 }

  self.jobs.cd_tut2 = deep_clone(self.jobs.short1)
  self.jobs.cd_tut2.name_id = "heist_short1_stage2_hl"
  self.jobs.cd_tut2.briefing_id = "heist_short1_stage2_briefing"
  self.jobs.cd_tut2.chain = { self.stages.short_1_2 }

  self.jobs.cd_tut3 = deep_clone(self.jobs.short2)
  self.jobs.cd_tut3.name_id = "heist_short2_stage1_hl"
  self.jobs.cd_tut3.briefing_id = "heist_short2_stage1_briefing"
  self.jobs.cd_tut3.chain = { self.stages.short_2_1 }

  self.jobs.cd_tutorial = deep_clone(self.jobs.short1)
  self.jobs.cd_tutorial.name_id = "heist_cd_tutorial"
  self.jobs.cd_tutorial.briefing_id = "heist_cd_tutorial_briefing"
  self.jobs.cd_tutorial.chain = { self.stages.short_1_1, self.stages.short_1_2, self.stages.short_2_1 }

  -- Standalone days
  self.jobs.cd_hox1 = deep_clone(self.jobs.hox)
  self.jobs.cd_hox1.name_id = "heist_hox_1_hl"
  self.jobs.cd_hox1.briefing_id = "heist_hox_1_briefing"
  self.jobs.cd_hox1.chain = { self.stages.hox_1 }

  self.jobs.cd_hox2 = deep_clone(self.jobs.hox)
  self.jobs.cd_hox2.name_id = "heist_hox_2_hl"
  self.jobs.cd_hox2.briefing_id = "heist_hox_2_briefing"
  self.jobs.cd_hox2.chain = { self.stages.hox_2 }
  self.jobs.cd_hox2.contact = "hoxton"

  self.jobs.hox_3.contact = "hoxton"

  self.jobs.cd_frame3 = deep_clone(self.jobs.framing_frame)
  self.jobs.cd_frame3.name_id = "heist_framing_frame_3_hl"
  self.jobs.cd_frame3.briefing_id = "heist_framing_frame_3_briefing"
  self.jobs.cd_frame3.chain = { self.stages.framing_frame_3 }

  self.jobs.cd_firestarter1 = deep_clone(self.jobs.firestarter)
  self.jobs.cd_firestarter1.name_id = "heist_firestarter_1_hl"
  self.jobs.cd_firestarter1.briefing_id = "heist_firestarter_1_briefing"
  self.jobs.cd_firestarter1.chain = { self.stages.firestarter_1 }

  self.jobs.cd_firestarter2 = deep_clone(self.jobs.firestarter)
  self.jobs.cd_firestarter2.name_id = "heist_firestarter_2_hl"
  self.jobs.cd_firestarter2.briefing_id = "heist_firestarter_2_briefing"
  self.jobs.cd_firestarter2.chain = { self.stages.firestarter_2 }

  self.jobs.cd_biker1 = deep_clone(self.jobs.born)
  self.jobs.cd_biker1.name_id = "heist_born_hl"
  self.jobs.cd_biker1.briefing_id = "heist_born_briefing"
  self.jobs.cd_biker1.chain = { self.stages.born }

  self.jobs.cd_biker2 = deep_clone(self.jobs.born)
  self.jobs.cd_biker2.name_id = "heist_chew_hl"
  self.jobs.cd_biker2.briefing_id = "heist_chew_briefing"
  self.jobs.cd_biker2.chain = { self.stages.chew }

  self.jobs.cd_bigoil = deep_clone(self.jobs.welcome_to_the_jungle_wrapper)
  self.jobs.cd_bigoil.name_id = "heist_welcome_to_the_jungle_2_hl"
  self.jobs.cd_bigoil.briefing_id = "heist_welcome_to_the_jungle_2_briefing"
  self.jobs.cd_bigoil.chain = { self.stages.welcome_to_the_jungle_2 }
  self.jobs.cd_bigoil.job_wrapper = nil

  self.jobs.cd_reservoir = deep_clone(self.jobs.rvd)
  self.jobs.cd_reservoir.name_id = "heist_rvd2_hl"
  self.jobs.cd_reservoir.briefing_id = "heist_rvd2_briefing"
  self.jobs.cd_reservoir.chain = { self.stages.rvd_2 }
  self.jobs.cd_reservoir.dlc = nil

  self.jobs.cd_miami1 = deep_clone(self.jobs.mia)
  self.jobs.cd_miami1.name_id = "heist_mia_1_hl"
  self.jobs.cd_miami1.briefing_id = "heist_mia_1_briefing"
  self.jobs.cd_miami1.chain = { self.stages.mia_1 }

  self.jobs.cd_miami2 = deep_clone(self.jobs.mia)
  self.jobs.cd_miami2.name_id = "heist_mia_2_hl"
  self.jobs.cd_miami2.briefing_id = "heist_mia_2_briefing"
  self.jobs.cd_miami2.chain = { self.stages.mia_2 }

  self.jobs.cd_goat1 = deep_clone(self.jobs.peta)
  self.jobs.cd_goat1.name_id = "heist_peta_hl"
  self.jobs.cd_goat1.briefing_id = "heist_peta_briefing"
  self.jobs.cd_goat1.chain = { self.stages.peta_1 }

  self.jobs.cd_goat2 = deep_clone(self.jobs.peta)
  self.jobs.cd_goat2.name_id = "heist_peta2_hl"
  self.jobs.cd_goat2.briefing_id = "heist_peta2_briefing"
  self.jobs.cd_goat2.chain = { self.stages.peta_2 }

  self.jobs.cd_rats = deep_clone(self.jobs.alex)
  self.jobs.cd_rats.name_id = "heist_alex_1_hl"
  self.jobs.cd_rats.briefing_id = "heist_alex_1_briefing"
  self.jobs.cd_rats.chain = { self.stages.alex_1 }

  -- Wrappers
  self.jobs.arm_wrapper = { -- I can't believe Sidetrack removed this completely unused contract :(
    name_id = "heist_arm_temp", briefing_id = "heist_arm_crimenet", contact = "bain",
    chain = { {} }, job_wrapper = { "arm_cro", "arm_und", "arm_hcm", "arm_par", "arm_fac" },
    payout = { 8500, 11000, 30000, 32000, 44000, 44000, 44000 },

    jc = 30, briefing_event = "pln_at1_brf_01",
    crimenet_callouts = { "pln_at1_cnc_01" }, crimenet_videos = { "cn_branchbank1", "cn_branchbank3" },
    experience_mul = { 1, 1, 1, 1.2, 1.2 }, contract_cost = { 16000, 32000, 80000, 160000, 200000, 200000, 200000 }
  }

  self.jobs.cd_erection1 = deep_clone(self.jobs.election_day)
  self.jobs.cd_erection1.name_id = "heist_election_day_2_hl"
  self.jobs.cd_erection1.briefing_id = "eday2_brief"
  self.jobs.cd_erection1.chain = { self.stages.election_day_2 }

  self.jobs.cd_erection2 = deep_clone(self.jobs.election_day)
  self.jobs.cd_erection2.name_id = "heist_election_day_3_hl"
  self.jobs.cd_erection2.briefing_id = "eday3_brief_skip1"
  self.jobs.cd_erection2.chain = { self.stages.election_day_3 }
  
  self.jobs.cd_erection_wrapper = deep_clone(self.jobs.arm_wrapper)
  self.jobs.cd_erection_wrapper.name_id = "heist_election_day"
  self.jobs.cd_erection_wrapper.briefing_id = "heist_election_day_crimenet"
  self.jobs.cd_erection_wrapper.contact = "the_elephant"
  self.jobs.cd_erection_wrapper.job_wrapper = { "cd_erection1", "cd_erection2" }
  self.jobs.cd_erection_wrapper.crimenet_videos = { "cn_elcday1", "cn_elcday2", "cn_elcday3" }
  self.jobs.cd_erection_wrapper.crimenet_callouts = { "elp_election_cmc_01" }

  self.jobs.cd_bomb = deep_clone(self.jobs.arm_wrapper)
  self.jobs.cd_bomb.name_id = "heist_bomb"
  self.jobs.cd_bomb.briefing_id = "heist_bomb_crimenet"
  self.jobs.cd_bomb.contact = "the_butcher"
  self.jobs.cd_bomb.job_wrapper = { "crojob1", "crojob_wrapper" }
  self.jobs.cd_bomb.crimenet_videos = { "cn_cro1", "cn_cro2", "cn_cro3" }
  self.jobs.cd_bomb.crimenet_callouts = { "butcher_cr1_cnc_01" }

  self.jobs.cd_watchdogs1_d = deep_clone(self.jobs.watchdogs)
  self.jobs.cd_watchdogs1_d.name_id = "heist_watchdogs_1_hl"
  self.jobs.cd_watchdogs1_d.briefing_id = "heist_watchdogs_1_briefing"
  self.jobs.cd_watchdogs1_d.chain = { self.stages.watchdogs_1_d }
  self.jobs.cd_watchdogs1_n = deep_clone(self.jobs.watchdogs)
  self.jobs.cd_watchdogs1_n.name_id = "heist_watchdogs_1_hl"
  self.jobs.cd_watchdogs1_n.briefing_id = "heist_watchdogs_1_briefing"
  self.jobs.cd_watchdogs1_n.chain = { self.stages.watchdogs_1_n }

  self.jobs.cd_watchdogs1_wrapper = deep_clone(self.jobs.watchdogs_wrapper)
  self.jobs.cd_watchdogs1_wrapper.name_id = "heist_watchdogs_1_hl"
  self.jobs.cd_watchdogs1_wrapper.briefing_id = "heist_watchdogs_1_briefing"
  self.jobs.cd_watchdogs1_wrapper.job_wrapper = { "cd_watchdogs1_d", "cd_watchdogs1_n" }

  self.jobs.cd_watchdogs2_d = deep_clone(self.jobs.watchdogs)
  self.jobs.cd_watchdogs2_d.name_id = "heist_watchdogs_2_hl"
  self.jobs.cd_watchdogs2_d.briefing_id = "heist_watchdogs_2_briefing"
  self.jobs.cd_watchdogs2_d.chain = { self.stages.watchdogs_2_d }
  self.jobs.cd_watchdogs2_n = deep_clone(self.jobs.watchdogs)
  self.jobs.cd_watchdogs2_n.name_id = "heist_watchdogs_2_hl"
  self.jobs.cd_watchdogs2_n.briefing_id = "heist_watchdogs_2_briefing"
  self.jobs.cd_watchdogs2_n.chain = { self.stages.watchdogs_2_n }

  self.jobs.cd_watchdogs2_wrapper = deep_clone(self.jobs.watchdogs_wrapper)
  self.jobs.cd_watchdogs2_wrapper.name_id = "heist_watchdogs_2_hl"
  self.jobs.cd_watchdogs2_wrapper.briefing_id = "heist_watchdogs_2_briefing"
  self.jobs.cd_watchdogs2_wrapper.job_wrapper = { "cd_watchdogs2_d", "cd_watchdogs2_n" }

  -- Payout adjustments
  local HeistChain = Global.CrimDusk.data["heist_chain" .. CrimDusk.IsPermadeath()]
  local HeistsPlayed = next(HeistChain) and #HeistChain or Global.CrimDusk.data["heists_won" .. CrimDusk.IsPermadeath()]
  self.jobs.vit.payout[1] = 40000 * HeistsPlayed

  -- Mini-campaign finales
  self.jobs.fex.payout[1] = 500000
  self.jobs.pent.payout[1] = 500000
  self.jobs.deep.payout[1] = 500000

  -- No payout
  self.jobs.cd_hox1.payout[1] = 0
  self.jobs.cd_hox2.payout[1] = 0
  self.jobs.cd_biker1.payout[1] = 0
  self.jobs.bph.payout[1] = 0 -- Hell's Island
  self.jobs.rat.payout[1] = 0 -- Cook Off (infinite)
  self.jobs.cd_goat1.payout[1] = 0

  -- Job chance
  self.jobs.cd_reservoir.spawn_chance_multiplier = 0.5
  self.jobs.bph.spawn_chance_multiplier = 0.25
  self.jobs.sand.spawn_chance_multiplier = 0.5
  self.jobs.hox_3.spawn_chance_multiplier = 0.5

  -- Job index
  table.insert(self._jobs_index, "arm_wrapper")
  table.insert(self._jobs_index, "cd_tut1")
  table.insert(self._jobs_index, "cd_tut2")
  table.insert(self._jobs_index, "cd_tut3")
  table.insert(self._jobs_index, "cd_tutorial")
  table.insert(self._jobs_index, "cd_hox1")
  table.insert(self._jobs_index, "cd_hox2")
  table.insert(self._jobs_index, "cd_frame3")
  table.insert(self._jobs_index, "cd_firestarter1")
  table.insert(self._jobs_index, "cd_firestarter2")
  table.insert(self._jobs_index, "cd_biker1")
  table.insert(self._jobs_index, "cd_biker2")
  table.insert(self._jobs_index, "cd_bigoil")
  table.insert(self._jobs_index, "cd_reservoir")
  table.insert(self._jobs_index, "cd_watchdogs1_wrapper")
  table.insert(self._jobs_index, "cd_watchdogs1_d")
  table.insert(self._jobs_index, "cd_watchdogs1_n")
  table.insert(self._jobs_index, "cd_watchdogs2_wrapper")
  table.insert(self._jobs_index, "cd_watchdogs2_d")
  table.insert(self._jobs_index, "cd_watchdogs2_n")
  table.insert(self._jobs_index, "cd_miami1")
  table.insert(self._jobs_index, "cd_miami2")
  table.insert(self._jobs_index, "cd_goat1")
  table.insert(self._jobs_index, "cd_goat2")
  table.insert(self._jobs_index, "cd_erection_wrapper")
  table.insert(self._jobs_index, "cd_erection1")
  table.insert(self._jobs_index, "cd_erection2")
  table.insert(self._jobs_index, "cd_bomb")
  table.insert(self._jobs_index, "cd_rats")
end)