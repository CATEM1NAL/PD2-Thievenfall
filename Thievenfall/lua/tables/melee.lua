Global.CrimDusk.melee = {}

Global.CrimDusk.melee.classes = {
  Unarmed = {
    fists = {},
    fight = {},
    moneybundle = {}
  },

  SmallObjects = {
    swagger = {},
    aziz = {},
    spatula = {},
    microphone = {},
    selfie = {},
    zeus = {},
    baton = {},
    chac = {},
    shock = {},
    oldbaton = {},
    detector = {},
    branding_iron = {},
    croupier_rake = {},
    brick = { rep = 0.4 },
    model24 = {},
    funder_strike = {},
    sap = {},
    bonk = {},
    bonk2 = {},
    micstand = {},
    taser = {},
    hammer = {},
    shillelagh = {},
    stick = {},
    piggy_hammer = {},
    whiskey = {},
    tenderizer = {},
    brass_knuckles = {},
    boxing_gloves = {},
    happy = { rep = 0.4 }
  },

  LargeObjects = {
    meter = {},
    alien_maul = {},
    briefcase = {},
    spoon = {},
    spoon_gold = {},
    shovel = {},
    cutters = {},
    baseballbat = {},
    slot_lever = {},
    hockey = { anim = "melee_baseballbat" },
    buck = {},
    dingdong = {},
    road = { rep = 0.55 },
    order = {},
  },

  Knives = {
    kabar = {},
    toothbrush = {},
    clean = { rep = 0.2 },
    kabartanto = {},
    nin = {},
    fork = {},
    shawn = {},
    boxcutter = {},
    bayonet = {},
    sword = {},
    fear = {},
    hauteur = {},
    ballistic = {},
    pugio = {},
    kampfmesser = {},
    wing = { rep = 0.5 },
    ostry = {},
    switchblade = {},
    grip = { rep = 0.3 },
    push = {},
    twins = {},
    bowie = {},
    chef = {},
    x46 = {},
    catch = { rep = 0.255 },
    scoutknife = {},
    gerber = {},
    fairbair = {},
    poker = {},
    cqc = {},
    rambo = {}
  },

  SmallBlades = {
    tiger = {},
    cs = { rep = 0.75, dismember = true },
    pitchfork = {  },
    sandsteel = { dismember = true },
    machete = { dismember = true },
    gator = { dismember = true },
    oxide = { dismember = true },
    agave = { rep = 0.3, dismember = true },
    bullseye = {  },
    scalper = { dismember = true },
    meat_cleaver = { dismember = true },
    cleaver = { dismember = true },
    tomahawk = { dismember = true },
    becker = { dismember = true },
    iceaxe = {  }
  },

  LargeBlades = {
    beardy = { dismember = true },
    mining_pick = {},
    morning = {},
    great = { dismember = true },
    freedom = {},
    fireaxe = { dismember = true, anim = "melee_baseballbat" },
    barbedwire = {}
  }
}

Global.CrimDusk.melee.stats = {
  -- Blunt melees
  Unarmed = {
    weapon_type = "blunt", charge_time = 1,
    min_damage = 2, max_damage = 4,
    min_damage_effect = 2, max_damage_effect = 2
  },
  SmallObjects = {
    weapon_type = "blunt", charge_time = 2,
    min_damage = 4, max_damage = 6,
    min_damage_effect = 2, max_damage_effect = 2
  },
  LargeObjects = {
    weapon_type = "blunt", charge_time = 3,
    min_damage = 6, max_damage = 8,
    min_damage_effect = 2, max_damage_effect = 2
  },

  -- Sharp melees
  Knives = {
    weapon_type = "sharp", charge_time = 1,
    min_damage = 2, max_damage = 5,
    min_damage_effect = 0.5, max_damage_effect = 0.5
  },
  SmallBlades = {
    weapon_type = "sharp", charge_time = 2,
    min_damage = 5, max_damage = 8,
    min_damage_effect = 0.5, max_damage_effect = 0.5
  },
  LargeBlades = {
    weapon_type = "sharp", charge_time = 3,
    min_damage = 8, max_damage = 11,
    min_damage_effect = 0.5, max_damage_effect = 0.5
  }
}

Global.CrimDusk.melee.equip = { melee_axe = 1, melee_baseballbat = 0.8, melee_machete = 1, melee_knife = 0.6, melee_knife2 = 0.25 }
Global.CrimDusk.melee.reset = { melee_axe = 0.35, melee_baseballbat = 0.8, melee_machete = 0.35, melee_knife = 0.6, melee_knife2 = 0.35 }
Global.CrimDusk.melee.damage_delay = { melee_baseballbat = 0.2 }