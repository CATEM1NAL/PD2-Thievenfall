-- I am **NOT** fucking around with actual achievement unlocks and I have no intention to.
-- This is purely to tweak some trophies so they're actually obtainable with the limitations of this mod.

local any = { "normal", "hard", "overkill", "overkill_145", "easy_wish", "overkill_290", "sm_wish" }
local postgame = { "sm_wish" }

Hooks:PostHook(AchievementsTweakData, "init", "CrimDusk_AchievementTweakRequirements", function(self)
  local complete = self.complete_heist_achievements
  -- Scrap Metal
  complete.trophy_friendly_car.num_players = nil
  complete.trophy_friendly_car.equipped_team = { num_skills = 1 }

  -- So Pretty
  complete.trophy_tiara.equipped_team = nil
  complete.trophy_tiara.difficulty = postgame

  -- Tickets, Please!
  complete.trophy_train_bomb.difficulty = postgame

  -- Turret
  self.loot_cash_achievements.trophy_tfturret.difficulties = postgame

  -- True Ace
  self.grenade_achievements.trophy_ace.difficulties = any

  -- The Robber
  complete.trophy_transport_crossroads.difficulty = postgame
  complete.trophy_transport_downtown.difficulty = postgame
  complete.trophy_transport_harbor.difficulty = postgame
  complete.trophy_transport_park.difficulty = postgame
  complete.trophy_transport_underpass.difficulty = postgame

  -- The Elephant In The Room
  complete.trophy_framing_frame = {
    stealth = true, trophy_stat = "trophy_framing_frame", difficulty = postgame, jobs = { "cd_frame3" }
  }

  -- Mercenary
  complete.trophy_flawless.mutators = nil
  complete.trophy_flawless.num_players = 2
  complete.trophy_flawless.difficulty = any

  -- Old Faithful
  complete.trophy_bank_heists.jobs = { "branchbank_prof" }
  complete.trophy_bank_heists.difficulty = postgame

  -- Longfellow
  complete.trophy_shoutout.difficulty = postgame

  -- I Just Had To
  complete.trophy_fbi.difficulty = postgame

  -- Humanitarian
  complete.trophy_courtesy.difficulty = postgame

  -- Get Off My Lawn!
  complete.trophy_defender.difficulty = postgame

  -- First Steps
  complete.trophy_basics_stealth.job = "cd_tut1"
  complete.trophy_basics_stealth_2 = { job = "cd_tut2", trophy_stat = "trophy_basics_stealth_2" }
  complete.trophy_basics_loud.job = "cd_tut3"

  -- Falcogini
  complete.trophy_car_shop.difficulty = postgame

  -- Failed Assassination
  complete.trophy_jfk.difficulty = postgame
  complete.trophy_jfk.equipped_team = { armor = "level_2", num_skills = 1, primary_category = "snp" }

  -- Disco Night
  complete.trophy_nightclub_dw.difficulty = postgame
  complete.trophy_nightclub_dw.stealth = nil
  complete.trophy_nightclub_dw.timer = 600

  -- Clueless
  complete.trophy_piggy_bank.difficulty = postgame
  complete.trophy_piggy_bank.timer = 480

  -- Evolution
  complete.trophy_evolution = {
    trophy_stat = "trophy_evolution", job = "nail", equipped_team = { deployable = "sentry_gun", reverse_deployable = true },
    everyone_killed_by_weapons = 0, everyone_killed_by_grenade = 0, everyone_killed_by_melee = 0
  }

  -- I Just Had To
  complete.trophy_fbi.job = "cd_firestarter2"
  complete.trophy_fbi.difficulty = postgame
  complete.trophy_fbi.levels = nil
  complete.trophy_fbi.stealth = nil
  complete.trophy_fbi.equipped_team = { num_skills = 0 }

  complete.trophy_fbi_hox = deep_clone(complete.trophy_fbi)
  complete.trophy_fbi_hox.job = "cd_hox2"
  complete.trophy_fbi_hox.trophy_stat = "trophy_fbi_hox"
  complete.trophy_fbi_hox.timer = 900

  complete.trophy_fbi_tag = deep_clone(complete.trophy_fbi)
  complete.trophy_fbi_tag.job = "tag"
  complete.trophy_fbi_tag.trophy_stat = "trophy_fbi_tag"
  complete.trophy_fbi.equipped_team = { num_skills = 0 }

  -- Who's There?
  local StealthHeists = {
    "four_stores", "cd_frame3", "cd_firestarter2", "family", "cd_erection1", "kosugi",
    "gallery", "crojob1", "cage", "kenaz", "dark", "fish", "dah", "tag", "chca", "nmh"
  }
  for _, heist in ipairs(StealthHeists) do
    complete["trophy_stealth_" .. heist] = { stealth = true, difficulty = postgame, trophy_stat = "trophy_stealth_" .. heist, job = heist }
  end

  -- Staying Alive
  complete.trophy_dance = {
    job = "nightclub", trophy_stat = "trophy_dance",
    everyone_killed_by_weapons = 0, everyone_killed_by_grenade = 0,
    equipped_team = { deployable = "trip_mine" }
  }

  -- Mother of Mothers
  complete.trophy_host.job = "vit"

  -- The First Line
  self.enemy_melee_hit_achievements.trophy_hockeykill = { trophy_stat = "trophy_hockeykill", is_not_civilian = true, melee_id = "hockey", result = "death" }

  -- Escape Van
  complete.trophy_escapes.difficulty = postgame
  complete.trophy_escapes.levels = {
    "four_stores", "ukrainian_job", "branchbank", "nightclub", "election_day_2", "election_day_3", "alex_1", "firestarter_1", "firestarter_2",
    "arm_und", "arm_cro", "arm_par", "family", "kosugi", "gallery", "cage", "rat", "spa", "rvd2", "bex", "chas"
  }

  -- Golden Grin
  complete.trophy_golden_grin = { trophy_stat = "trophy_golden_grin", jobs = { "kenaz" }, difficulty = postgame }

  -- Side Jobs
  self.grenade_achievements.cg22_personal_1.mutators = nil
  self.enemy_kill_achievements.cg22_personal_2.mutators = nil
  self.enemy_kill_achievements.cg22_personal_2.weapons = nil
  self.enemy_kill_achievements.cg22_personal_3.mutators = nil
  self.enemy_kill_achievements.cg22_personal_3.difficulty = nil
end)