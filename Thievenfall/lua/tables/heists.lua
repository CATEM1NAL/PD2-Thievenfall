Global.CrimDusk.heists = {}

--[[
Example heist entries:

  ...
  stealthable_heist_id = { unmasked = true, stealthable = true, bonus = "x", grading = "color_x", suit = "suit_x" },
  loud_heist_id = { delay = 5, grading = "color_y", suit = "suit_y" },
  ...

**unmasked**: whether you spawn unmasked on this heist. uses default spawn state if not set.
**stealthable**: whether this heist can be stealthed. if this isn't set, the heist will go loud upon masking up.
**bonus**: stealth bonus assigned to this heist. value is a string that references the stealth bonuses table.
**delay**: how many seconds it takes to go loud after masking up if heist is unstealthable. default is 3.
**grading**: default colour grading to apply to this heist. the irony isn't lost on me, I promise.
**suit**: suit worn when no custom suit is used.
]]

Global.CrimDusk.stealth_bonuses = { rng = 0.05, small = 0.1, big = 0.25, unmasked = 0.5 }
Global.CrimDusk.heists = {
  -- Safehouse
  chill = { unmasked = true, stealthable = true, grading = "color_xgen", suit = "suit" },
  chill_combat = { stealthable = true, grading = "color_xgen", suit = "slaughterhouse" },

  -- PDTH
  red2 = { grading = "color_bhd", suit = "suit" },
  flat = { grading = "color_nice", suit = "suit" },
  pal = { stealthable = true, grading = "color_xgen" },
  man = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  nmh = { stealthable = true, bonus = "big", grading = "color_matrix_classic", suit = "suit" },
  dinner = { grading = "color_bhd" },
  run = { stealthable = true, grading = "color_bhd", suit = "suit" },
  glace = { stealthable = true, grading = "color_bhd" },
  dah = { unmasked = true, stealthable = true, bonus = "small", grading = "color_xxxgen", suit = "suit" },

  -- Tutorials
  short1_stage1 = { stealthable = true, bonus = "small", grading = "color_bhd", suit = "sneak_suit" },
  short1_stage2 = { stealthable = true, bonus = "small", grading = "color_heat", suit = "sneak_suit" },
  short2_stage1 = { grading = "color_nice", suit = "suit" },

  -- Launch heists
  four_stores = { bonus = "unmasked", grading = "color_heat", suit = "suit" },
  mallcrasher = { grading = "color_heat", suit = "suit" },
  branchbank = { grading = "color_xgen", suit = "suit" },
  ukrainian_job = { bonus = "rng", grading = "color_nice", suit = "suit" },
  nightclub = { grading = "color_xxxgen", suit = "suit" },
  watchdogs_1 = { stealthable = true, grading = "color_heat", suit = "slaughterhouse" },
  watchdogs_1_night = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  watchdogs_2 = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  watchdogs_2_day = { stealthable = true, grading = "color_xgen", suit = "slaughterhouse" },
  framing_frame_3 = { stealthable = true, bonus = "big", grading = "color_bhd", suit = "sneak_suit" },
  welcome_to_the_jungle_2 = { stealthable = true, grading = "color_xgen", suit = "slaughterhouse" },
  firestarter_1 = { delay = 5, grading = "color_xxxgen", suit = "slaughterhouse" },
  firestarter_2 = { stealthable = true, bonus = "big", grading = "color_bhd", suit = "sneak_suit" },
  alex_1 = { stealthable = true, grading = "color_xxxgen", suit = "suit" },

  -- Post-launch
  family = { stealthable = true, bonus = "small", grading = "color_heat", suit = "suit" },
  roberts = { grading = "color_xgen", suit = "suit" },
  election_day_2 = { stealthable = true, bonus = "small", grading = "color_xxxgen", suit = "sneak_suit" },
  election_day_3 = { grading = "color_nice", suit = "suit" },
  kosugi = { stealthable = true, bonus = "small", grading = "color_bhd", suit = "sneak_suit" },
  gallery = { stealthable = true, bonus = "small", grading = "color_bhd", suit = "sneak_suit" },
  pines = { stealthable = true, grading = "color_bhd", suit = "rusbear" },
  cage = { stealthable = true, bonus = "big", grading = "color_xgen", suit = "suit" },
  hox_3 = { grading = "color_xxxgen", suit = "slaughterhouse" },
  shoutout_raid = { stealthable = true, grading = "color_heat", suit = "slaughterhouse" },
  arena = { grading = "color_bhd", suit = "leatherfluff" },
  jolly = { stealthable = true, suit = "slaughterhouse" },
  cane = { grading = "color_bhd", suit = "elfsuit" },
  peta = { stealthable = true, grading = "color_heat", suit = "suit" },
  peta2 = { stealthable = true, grading = "color_xxxgen", suit = "suit" },
  dark = { unmasked = true, stealthable = true, bonus = "big", grading = "color_bhd", suit = "cable_guy" },
  mad = { stealthable = true, grading = "color_bhd", suit = "winter_suit" },
  born = { stealthable = true, grading = "color_xxxgen", suit = "suit" },
  chew = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  moon = { stealthable = true, grading = "color_nice", suit = "lonorwa" },
  spa = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  fish = { unmasked = true, stealthable = true, bonus = "small", grading = "color_xxxgen", suit = "tux" },
  rvd2 = { stealthable = true, grading = "color_xxxgen", suit = "suit" },

  -- Transport
  arm_cro = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  arm_hcm = { stealthable = true, grading = "color_heat", suit = "slaughterhouse" },
  arm_par = { stealthable = true, grading = "color_heat", suit = "slaughterhouse" },
  arm_fac = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  arm_und = { stealthable = true, grading = "color_xxxgen", suit = "jumpsuit" },
  arm_for = { delay = 10, grading = "color_nice", suit = "slaughterhouse" },

  -- Dentist
  big = { suit = "suit" },
  mia_1 = { stealthable = true, grading = "color_bhd", suit = "suit" },
  mia_2 = { grading = "color_xxxgen", suit = "slaughterhouse" },
  hox_1 = { stealthable = true, grading = "color_bhd", suit = "slaughterhouse" },
  hox_2 = { stealthable = true, grading = "color_nice", suit = "slaughterhouse" },
  mus = { unmasked = true, grading = "color_xxxgen", suit = "cable_guy" },
  kenaz = { stealthable = true, bonus = "big", grading = "color_xgen", suit = "suit" },

  -- Butcher
  crojob2 = { unmasked = true, stealthable = true, bonus = "small", grading = "color_xxxgen", suit = "cable_guy" },
  crojob3 = { stealthable = true, grading = "color_bhd", suit = "slaughterhouse" },
  crojob3_night = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  friend = { delay = 8, grading = "color_xxxgen", suit = "slaughterhouse" },

  -- Locke
  pbr = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  pbr2 = { grading = "color_bhd", suit = "slaughterhouse" },
  wwh = { stealthable = true, grading = "color_bhd" },
  brb = { stealthable = true, grading = "color_bhd", suit = "rusbear" },
  tag = { stealthable = true, bonus = "big", grading = "color_bhd", suit = "sneak_suit" },
  des = { grading = "color_xxxgen", suit = "slaughterhouse" },
  sah = { grading = "color_bhd" },
  bph = { stealthable = true, grading = "color_bhd" },
  vit = { delay = 9 },

  -- Silk Road
  mex = { unmasked = true, grading = "color_bhd", suit = "bikervest" },
  bex = { grading = "color_bhd", suit = "suit" },
  pex = { unmasked = true, grading = "color_bhd", suit = "suit" },
  fex = { unmasked = true, grading = "color_xxxgen", suit = "suit" },

  -- City of Gold
  chas = { grading = "color_xxxgen", suit = "suit" },
  sand = { delay = 10, grading = "color_bhd", suit = "slaughterhouse" },
  chca = { stealthable = true, bonus = "big", grading = "color_xxxgen", suit = "tux" },
  pent = { grading = "color_bhd", suit = "suit" },

  -- Texas Heat
  ranc = { unmasked = true, grading = "color_xxxgen", suit = "bullranch" },
  trai = { unmasked = true, grading = "color_heat", suit = "raincoat" },
  corp = { grading = "color_xgen", suit = "suit" },
  deep = { delay = 15, grading = "color_heat", suit = "slaughterhouse" },

  -- Sidetrack
  auc = { delay = 2, grading = "color_xxxgen", suit = "suit" },

  -- Post-game
  hvh = { stealthable = true, grading = "color_matrix_classic", suit = "haunted" },
  help = { stealthable = true, grading = "color_matrix_classic", suit = "classyske" },
  nail = { stealthable = true, grading = "color_matrix_classic", suit = "moneysuit" },
  haunted = { stealthable = true, grading = "color_matrix_classic", suit = "moneysuit" },
  rat = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },

  -- Holdout
  skm_mus = { stealthable = true, grading = "color_xxxgen", suit = "cable_guy" },
  skm_red2 = { stealthable = true, grading = "color_bhd", suit = "suit" },
  skm_run = { stealthable = true, grading = "color_bhd", suit = "suit" },
  skm_watchdogs_stage2 = { stealthable = true, grading = "color_xxxgen", suit = "slaughterhouse" },
  skm_bex = { stealthable = true, grading = "color_bhd", suit = "suit" },
  skm_cas = { stealthable = true, grading = "color_xgen", suit = "suit" },
  skm_big2 = { stealthable = true, suit = "suit" },
  skm_mallcrasher = { stealthable = true, grading = "color_heat", suit = "suit" },
  skm_arena = { stealthable = true, grading = "color_bhd", suit = "leatherfluff" }
}