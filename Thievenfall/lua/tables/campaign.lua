-- MAIN CAMPAIGN
Global.CrimDusk.campaign = { -- Main campaign
  "red2", "flat", "pal", "man", "nmh", -- PDTH Prologue
  "cd_tut1", "cd_tut2", "cd_tut3", "four_stores", "mallcrasher", "branchbank_prof", "ukrainian_job_prof", "nightclub", -- Early Vlad
  "cd_watchdogs1_wrapper", "cd_watchdogs2_wrapper", "cd_frame3", "cd_bigoil", "cd_firestarter1", "cd_firestarter2", "cd_rats", -- Hector/Elephant
  "family", "arm_wrapper", "arm_for", "roberts", "cd_erection_wrapper", "kosugi", -- Post Launch
  "big", "cd_miami1", "cd_miami2", "gallery", "cd_hox1", "cd_hox2", "auc", "pines", "mus", -- Dentist
  "cd_bomb", "cage", "hox_3", "shoutout_raid", "arena", "kenaz", "jolly", "dinner", "pbr", "pbr2", "cane", -- 2015
  "cd_goat1", "cd_goat2", "dark", "mad", "cd_biker1", "cd_biker2", "moon", "friend", -- 2016
  "spa", "fish", "run", "glace", "wwh", "dah", "cd_reservoir", "brb", "tag", "des", "sah", -- Final Arc
  "mex", "chas", "bex", "sand", "pex", "chca", "fex", "pent", "bph", "ranc", "trai", "corp", -- Bopocalypse
  "deep", "vit" -- Conclusion
}

-- POST-GAME CAMPAIGN DATA
Global.CrimDusk.custom_campaign_base = {
  "red2", "flat", "pal", "man", "nmh", "dah", "dinner", -- PDTH
  "branchbank_prof", "family", "arm_wrapper", "arm_for", "roberts", "gallery", "cage", "arena", "cd_reservoir", "auc", -- Bain
  "four_stores", "mallcrasher", "ukrainian_job_prof", "nightclub", "cane", "jolly", "pines", "moon", -- Vlad
  "cd_firestarter1", "cd_firestarter2", "cd_rats", -- Hector
  "cd_frame3", "cd_bigoil", "cd_erection_wrapper", -- Elephant
  "big", "mus", -- Dentist
  "friend" -- Butcher
}

Global.CrimDusk.mini_campaign_data = {
  -- Campaign events
  hector_dead = { cd_watchdogs1_wrapper = true, cd_watchdogs2_wrapper = true, cd_firestarter1 = true, cd_firestarter2 = true, cd_rats = true },
  bain_captured = { brb = true, tag = true, des = true, sah = true, bph = true, nmh = true },
  almir_captured = { pines = true, moon = true, cd_goat2 = true },
  dentist = { cd_miami1 = true, cd_miami2 = true, cd_hox1 = true, big = true, mus = true, kenaz = true },
  vlad_captured = {
    four_stores = true, mallcrasher = true, ukrainian_job_prof = true, nightclub = true, pines = true, cane = true,
    moon = true, jolly = true, shoutout_raid = true, cd_goat1 = true, cd_goat2 = true, bex = true, pex = true, fex = true
  },

  -- Heist chains
  hardcore_henry = { dark = 1, mad = 2 },
  biker_heist = { cd_biker1 = 1, cd_biker2 = 2 },
  watchdogs = { cd_watchdogs1_wrapper = 1, cd_watchdogs2_wrapper = 2 },
  search_for_kento = { run = 1, glace = 2 },
  continental = { spa = 1, fish = 2 },
  point_break = { pbr = 1, pbr2 = 2 },
  alaskan = { cd_bomb = 1, wwh = 2 },

  longfellow = { kosugi = 1, shoutout_raid = 2, cd_goat1 = 3, cd_goat2 = 4 },
  free_hoxton = { cd_miami1 = 1, cd_miami2 = 2, cd_hox1 = 3, cd_hox2 = 4, hox_3 = 5 },
  silk_road = { mex = 1, bex = 2, pex = 3, fex = 4 },
  city_of_gold = { chas = 1, sand = 2, chca = 3, pent = 4 },
  texas_heat = { ranc = 1, trai = 2, corp = 3, deep = 4 }
}

Global.CrimDusk.mini_campaigns = {}
for campaign, data in pairs(Global.CrimDusk.mini_campaign_data) do
  Global.CrimDusk.mini_campaigns[campaign] = {}

  for heist, num in pairs(data) do
    if type(num) == "number" then Global.CrimDusk.mini_campaigns[campaign][num] = heist end
  end

  if not next(Global.CrimDusk.mini_campaigns[campaign]) then Global.CrimDusk.mini_campaigns[campaign] = nil end
end

Global.CrimDusk.job_to_wrapper = {
  cd_watchdogs1_d = "cd_watchdogs1_wrapper", cd_watchdogs1_n = "cd_watchdogs1_wrapper",
  cd_watchdogs2_n = "cd_watchdogs2_wrapper", cd_watchdogs2_d = "cd_watchdogs2_wrapper",
  crojob1 = "cd_bomb", crojob_wrapper = "cd_bomb", cd_erection1 = "cd_erection_wrapper", cd_erection2 = "cd_erection_wrapper",
  arm_cro = "arm_wrapper", arm_und = "arm_wrapper", arm_hcm = "arm_wrapper", arm_par = "arm_wrapper", arm_fac = "arm_wrapper"
}

-- Which heists require which DLCs. Used to prevent random campaigns from softlocking; owning all heists is highly recommended!
Global.CrimDusk.heist_dlc = {
  arm_wrapper = "armored_transport", arm_for = "armored_transport", big = "big_bank", cd_miami1 = "hl_miami", cd_miami2 = "hl_miami",
  mus = "hope_diamond", cd_bomb = "the_bomb", arena = "arena", kenaz = "kenaz", pbr = "berry", pbr2 = "berry", cd_goat1 = "peta",
  cd_goat2 = "peta", pal = "pal", man = "pal", cd_biker1 = "born", cd_biker2 = "born", friend = "friend", spa = "spa", fish = "spa",
  mex = "mex", bex = "bex", pex = "pex", fex = "fex", chas = "chas", sand = "sand", chca = "chca", pent = "pent", ranc = "ranc",
  trai = "trai", corp = "corp", deep = "deep", auc = "auc"
}