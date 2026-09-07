Global.CrimDusk.weapons = {}

--[[
Weapons fall into classes. Each class has subclasses.
Classes and subclasses dictate the core weapon stats.
Low damage rifles will all deal the same damage, etc.

The following values exist:
**dmg**: can be a direct damage value, but should be a lookup string to find the correct damage subclass.
**dmgmult**: allows overriding the damage multiplier that exists for some weapons (snipers, etc).
**ap**: lookup string to determine the type of penetration the weapon uses.

**mag:** overrides base magazine capacity.
**nummags**: overrides max number of magazines.
**acc**: overrides base spread index.
**stab**: overrides base recoil index.
**reload**: overrides base reload speed.
**rof**: overrides fire rate. value assigned as rpm, converted to correct format later.
**pickup**: overrides ammo pickup if needed. can assign table directly, recommended to use lookup string.

**chamber**: number of rounds this weapon can chamber. defaults to 1 if not assigned.
**magdump**: whether this weapon should lose unfired & unchambered rounds on reload. no effect on hand-loaded weapons.
]]

Global.CrimDusk.weapons.classes = {
  rifles = {
    hailstorm = { dmg = 12, chamber = 0 },

    famas = { dmg = "low", acc = 19 },
    asval = { dmg = "low", mag = 20 },
    corgi = { dmg = "low" },
    vhs = { dmg = "low" },
    galil = { dmg = "low", acc = 19 },
    komodo = { dmg = "low" },
    m16 = { dmg = "low", mag = 20, reload = 20 },
    tkb = { dmg = "low", chamber = 3 },

    s552 = { dmg = "med", acc = 19 },
    aug = { dmg = "med" },
    groza = { dmg = "med" },
    sub2000 = { dmg = "med" },
    g36 = { dmg = "med", acc = 19 },
    l85a2 = { dmg = "med" },
    new_m14 = { dmg = "med" },
    ak5 = { dmg = "med" },
    fal = { dmg = "med" },
    hajk = { dmg = "med" },

    scar = { dmg = "high", mag = 20 },
    ak74 = { dmg = "high", acc = 16 },
    new_m4 = { dmg = "high", acc = 19 },
    flint = { dmg = "high" },
    tecci = { dmg = "high", nummags = 2, acc = 11 },
    contraband = { dmg = "high" },
    g3 = { dmg = "high", mag = 20 },

    amcar = { dmg = "vhigh", acc = 16 },
    akm = { dmg = "vhigh" },
    akm_gold = { dmg = "vhigh" },
    shak12 = { dmg = "vhigh", acc = 16 },
  },

  shotguns = {
    striker = { dmg = "base", acc = 5, chamber = 0 },
    basset = { dmg = "base", acc = 3 },
    rota = { dmg = "base", acc = 5, chamber = 0 },
    sko12 = { dmg = "base", acc = 3 },
    saiga = { dmg = "base", acc = 3, mag = 5, reload = 20 },
    aa12 = { dmg = "base", acc = 3, reload = 20 },
    serbu = { dmg = "base", acc = 5 },
    ultima = { dmg = "base", acc = 5 },
    judge = { dmg = "base", acc = 5, chamber = 0 },
    spas12 = { dmg = "base", acc = 5 },
    r870 = { dmg = "base", acc = 9 },
    benelli = { dmg = "base", acc = 5 },
    ksg = { dmg = "base", acc = 9 },
    m1897 = { dmg = "base", acc = 9 },
    supernova = { dmg = "base", acc = 9 },
    m37 = { dmg = "base", acc = 9 },
    m590 = { dmg = "base", acc = 5 },
    boot = { dmg = "base", acc = 17 },
    b682 = { dmg = "base", acc = 17, magdump = false, chamber = 0 },
    huntsman = { dmg = "base", acc = 17, chamber = 0 },
    coach = { dmg = "base", acc = 17, magdump = false, chamber = 0 }
  },

  lmgs = {
    mg42 = { dmg = "low", ap = "none", chamber = 0 },
    kacchainsaw = { dmg = "low", ap = "none", chamber = 0 },
    m249 = { dmg = "low", ap = "none", chamber = 0 },
    par = { dmg = "low", ap = "none", chamber = 0 },

    rpk = { dmg = "med", ap = "none" },
    hk21 = { dmg = "med", ap = "none" },
    hk51b = { dmg = "med", ap = "none" },

    hcar = { dmg = "high", ap = "none" },
    m60 = { dmg = "high", ap = "none", chamber = 0 }
  },

  snipers = {
    bessy = { dmgmult = 1, dmg = 50, ap = "none", chamber = 0 },
    m95 = { dmgmult = 100, dmg = 15, ap = "full" },

    wa2000 = { dmg = "low", ap = "none" },
    siltstone = { dmg = "low", ap = "none" },
    qbu88 = { dmg = "low", ap = "none" },
    tti = { dmg = "low", ap = "none" },
    victor = { dmg = "low", ap = "none" },
    ching = { dmg = "low", ap = "none", rof = 150, chamber = 0 },

    msr = { dmg = "low", ap = "basic" },
    winchester1874 = { dmg = "low", ap = "basic" },
    scout = { dmg = "low", ap = "basic" },
    r700 = { dmg = "low", ap = "basic" },

    r93 = { dmg = "high", ap = "shields" },
    model70 = { dmg = "high", ap = "shields" },
    desertfox = { dmg = "high", ap = "shields" },
    mosin = { dmg = "high", ap = "shields" },
    contender = { dmg = "high", ap = "shields", chamber = 0 },
    awp = { dmg = "high", ap = "full" },
    sbl = { dmg = "high", ap = "basic" }
  },

  pistols = {
    glock_18c = { dmg = "auto" },
    czech = { dmg = "auto" },
    beer = { dmg = "auto" },

    stech = { dmg = "low" },
    b92fs = { dmg = "low" },
    glock_17 = { dmg = "low" },
    ppk = { dmg = "low" },
    legacy = { dmg = "low" },
    g22c = { dmg = "low" },
    shrew = { dmg = "low" },
    g26 = { dmg = "low" },
    holt = { dmg = "low" },
    maxim9 = { dmg = "low" },
    pl14 = { dmg = "low" },
    packrat = { dmg = "low" },
    welrod = { dmg = "low" },
    jowi = { dmg = "low" },
    x_g17 = { dmg = "low" },

    p226 = { dmg = "med" },
    colt_1911 = { dmg = "med" },
    x_1911 = { dmg = "med" },
    m1911 = { dmg = "med" },
    c96 = { dmg = "med" },
    type54 = { dmg = "med" },
    breech = { dmg = "med" },
    hs2000 = { dmg = "med" },
    pmm = { dmg = "med" },
    usp = { dmg = "med" },
    sparrow = { dmg = "med" },

    lemming = { dmg = "high", ap = "basic" },
    model3 = { dmg = "high", chamber = 0 }
  },

  revolvers = {
    deagle = { dmg = "low", mag = 9 },
    mateba = { dmg = "low", ap = "none", chamber = 0 },
    x_2006m = { dmg = "low", ap = "none", chamber = 0 },
    korth = { dmg = "low", ap = "none", chamber = 0 },

    peacemaker = { dmgmult = 1, dmg = 100, ap = "basic", chamber = 0 },

    new_raging_bull = { dmg = "high", ap = "basic", rof = 120, acc = 21, stab = 1, chamber = 0 },
    x_rage = { dmg = "high", ap = "basic", rof = 120, acc = 11, stab = 1, chamber = 0 },
    chinchilla = { dmg = "high", ap = "basic", rof = 240, acc = 9, stab = 21, chamber = 0 },

    rsh12 = { dmg = 75, ap = "shields", rof = 90, chamber = 0 }
  },

  smgs = {
    cobray = { dmg = "vlow", chamber = 0 },
    pm9 = { dmg = "vlow" },
    fmg9 = { dmg = "vlow" },
    baka = { dmg = "vlow" },
    polymer = { dmg = "vlow" },
    mac10 = { dmg = "vlow", chamber = 0 },
    mp7 = { dmg = "vlow" },
    mp9 = { dmg = "vlow" },
    p90 = { dmg = "vlow" },
    tec9 = { dmg = "vlow" },
    scorpion = { dmg = "vlow" },

    akmsu = { dmg = "low" },
    vityaz = { dmg = "low" },
    new_mp5 = { dmg = "low" },
    x_mp5 = { dmg = "low" },
    m1928 = { dmg = "low", chamber = 0 },
    shepheard = { dmg = "low" },
    sr2 = { dmg = "low" },
    uzi = { dmg = "low", chamber = 0 },

    m45 = { dmg = "med", chamber = 0 },
    schakal = { dmg = "med" },
    olympic = { dmg = "med", reload = 20 },
    erma = { dmg = "med", chamber = 0 },
    coal = { dmg = "med" },

    speen = { dmg = "high" },
    sterling = { dmg = "high", mag = 32, chamber = 0 }
  },

  special = {
    flamethrower_mk2 = { dmg = "flame", pickup = "flame", chamber = 0 },
    system = { dmg = "flame", pickup = "flame", chamber = 0 },
    money = { dmg = "flame", pickup = "flame", chamber = 0 },

    hunter = { dmg = "xlow", pickup = "none", nummags = 15, chamber = 0 },
    ecp = { dmg = "xlow", pickup = "none", magdump = false, chamber = 0 },
    arblast = { dmg = "xhigh", pickup = "none", nummags = 5, chamber = 0 },
    frankish = { dmg = "xhigh", pickup = "none", nummags = 10, chamber = 0 },

    plainsrider = { dmg = "rpg", pickup = "none", nummags = 15, chamber = 0 },
    long = { dmgmult = 10, dmg = "bow", pickup = "none", nummags = 10, chamber = 0 },
    elastic = { dmgmult = 10, dmg = "bow", pickup = "none", nummags = 10, chamber = 0 },

    rpg7 = { dmg = "rpg", pickup = "none", nummags = 3, chamber = 0 },
    ray = { dmgmult = 25, dmg = "rpg", pickup = "none", chamber = 0 },

    shuno = { dmg = "mini", chamber = 0 },
    m134 = { dmg = "mini", chamber = 0 },

    china = { dmgmult = 1, dmg = "gl", nummags = 1, chamber = 0 },
    ms3gl = { dmgmult = 1, dmg = "gl", chamber = 0 },
    arbiter = { dmgmult = 1, dmg = "gl", chamber = 0 },
    gre_m79 = { dmgmult = 2, dmg = "gl", chamber = 0 },
    slap = { dmgmult = 2, dmg = "gl", chamber = 0 },
    m32 = { dmgmult = 2, dmg = "gl", nummags = 1, chamber = 0 },

    saw = { chamber = 0 },
    saw_secondary = { chamber = 0 }
  }
}

Global.CrimDusk.weapons.damage = {
  rifles = { low = 24, med = 32, high = 46, vhigh = 92 },
  shotguns = { base = 20 },
  lmgs = { low = 24, med = 32, high = 46 },
  snipers = { low = 75, high = 50 }, -- low x2, high x4
  pistols = { auto = 16, low = 32, med = 46, high = 65 },
  revolvers = { low = 80, high = 120 },
  smgs = { vlow = 16, low = 24, med = 32, high = 46 },
  special = { flame = 4, xlow = 12, xhigh = 20, rpg = 15, mini = 23, bow = 30, gl = 150 }
}

Global.CrimDusk.weapons.ap = {
  none = { enemy = true },
  basic = { ap = 1, enemy = true },
  shields = { ap = 1, enemy = true, shield = true },
  full = { ap = 1, enemy = true, shield = true, wall = true }
}

Global.CrimDusk.weapons.spread = {
  rifles = { -- Baseline. Solid when stationary, worse but not unusable when moving.
    standing = 2, crouching = 1, steelsight = 1.25,
    moving_standing = 4, moving_crouching = 2, moving_steelsight = 1
  },
  shotguns = { -- Unaffected by movement.
    standing = 2.5, crouching = 1.5, steelsight = 1.2,
    moving_standing = 2.5, moving_crouching = 1.5, moving_steelsight = 1
  },
  lmgs = { -- The action movie experience.
    standing = 4, crouching = 3, steelsight = 1.2,
    moving_standing = 2, moving_crouching = 1.5, moving_steelsight = 1
  },
  snipers = { -- Incredibly precise while stationary, dogshit otherwise.
    standing = 1, crouching = 0.5, steelsight = 1.5,
    moving_standing = 8, moving_crouching = 4, moving_steelsight = 1
  },
  pistols = { -- Secondary baseline. All around solid, but leaves something to be desired.
    standing = 3, crouching = 2, steelsight = 1.2,
    moving_standing = 4.5, moving_crouching = 2.5, moving_steelsight = 1
  },
  revolvers = { -- The sniper rifles of the pistol world.
    standing = 1.5, crouching = 1, steelsight = 1.25,
    moving_standing = 6, moving_crouching = 4, moving_steelsight = 1
  },
  smgs = { -- Worse than pistol, but unaffected by movement.
    standing = 4, crouching = 3, steelsight = 1.2,
    moving_standing = 4, moving_crouching = 3, moving_steelsight = 1
  },
  special = { -- All special weapons use this. May be too broad of a category?
    standing = 1, crouching = 1, steelsight = 1.25,
    moving_standing = 2, moving_crouching = 2, moving_steelsight = 1
  }
}

Global.CrimDusk.weapons.magazines = {
  rifles = 5, shotguns = 4, lmgs = 2, snipers = 3, pistols = 4, revolvers = 2, smgs = 5, special = 2
}

Global.CrimDusk.weapons.pickup = {
  none = { 0, 0 }, flame = { 18, 22 }
}

Global.CrimDusk.weapons.akimbo = { jowi = true, x_g17 = true, x_mp5 = true, x_1911 = true, x_2006m = true, x_rage = true }

Global.CrimDusk.weapons.crew = {
  new_mp5 = "mp5_crew", new_m4 = "m4_crew", new_m14 = "m14_crew", new_raging_bull = "raging_bull_crew",
  glock_17 = "g17_crew", b92fs = "beretta92_crew", glock_18c = "glock_18_crew", colt_1911 = "c45_crew"
}

-- Projectile damage
local Grenade = 40

local HighLauncher = 30
local LowLauncher = 15
local ShockLauncher = 1

local Bow = 15
local BowPoison = Bow * 0.75
local BowExp = Bow * 1.5

local Crossbow = Bow * 0.8
local CrossbowPoison = Crossbow * 0.75
local CrossbowExp = Crossbow * 1.5

Global.CrimDusk.weapons.projectile_damage = {

  -- frags
  frag = Grenade, dynamite = Grenade, dada_com = Grenade, frag_com = Grenade * 0.5, sticky_grenade = Grenade,
  -- special grenades
  wpn_gre_electric = ShockLauncher * 2.5, poison_gas_grenade = 0, molotov = 0, fir_com = 0,
  -- thrown
  wpn_prj_four = 7.5, wpn_prj_ace = 0.1, wpn_prj_jav = 50, wpn_prj_hur = 15, wpn_prj_target = 15, xmas_snowball = 10,

  -- frag launchers
  launcher_frag = HighLauncher, launcher_frag_slap = HighLauncher,
  launcher_frag_m32 = HighLauncher, launcher_frag_china = LowLauncher, launcher_frag_arbiter = LowLauncher, launcher_frag_ms3gl = LowLauncher,
  -- incendiary launchers
  launcher_incendiary = 0, launcher_incendiary_slap = 0,
  launcher_incendiary_m32 = 0, launcher_incendiary_china = 0, launcher_incendiary_arbiter = 0, launcher_incendiary_ms3gl = 0,
  -- shock launchers
  launcher_electric = ShockLauncher, launcher_electric_slap = ShockLauncher,
  launcher_electric_m32 = ShockLauncher, launcher_electric_china = ShockLauncher, launcher_electric_arbiter = ShockLauncher, launcher_electric_ms3gl = ShockLauncher,
  -- poison launchers
  launcher_poison = 0, launcher_poison_gre_m79 = 0, launcher_poison_slap = 0,
  launcher_poison_m32 = 0, launcher_poison_china = 0, launcher_poison_arbiter = 0, launcher_poison_ms3gl_conversion = 0,

  -- frag underbarrels
  launcher_m203 = HighLauncher, underbarrel_m203_groza = HighLauncher,
  -- shock underbarrels
  underbarrel_electric = ShockLauncher, underbarrel_electric_groza = ShockLauncher,
  -- poison underbarrels
  launcher_poison_contraband = 0, launcher_poison_groza = 0,

  -- standard bows
  west_arrow = Bow, long_arrow = Bow * 2, elastic_arrow = Bow * 2,
  -- explosive bows
  west_arrow_exp = BowExp, long_arrow_exp = BowExp * 2, elastic_arrow_exp = BowExp * 2,
  -- poison bows
  bow_poison_arrow = BowPoison, long_poison_arrow = BowPoison * 2, elastic_arrow_poison = BowPoison * 2,

  -- standard crossbows
  crossbow_arrow = Crossbow, frankish_arrow = Grenade, arblast_arrow = 200, ecp_arrow = Crossbow,
  -- explosive crossbows
  crossbow_arrow_exp = CrossbowExp, frankish_arrow_exp = Grenade * 1.5, arblast_arrow_exp = 300, ecp_arrow_exp = CrossbowExp,
  -- poison crossbows
  crossbow_poison_arrow = CrossbowPoison, frankish_poison_arrow = Grenade * 0.75, arblast_poison_arrow = 100, ecp_arrow_poison = CrossbowPoison,

  -- other
  launcher_rocket = 150, rocket_ray_frag = 37.5
}

-- Throwable stats; cooldown = { throwable = quantity }
Global.CrimDusk.weapons.throwables = {
  [12] = { xmas_snowball = 2 },
  [30] = { laser_watch = 8, wpn_gre_electric = 1, concussion = 2, fir_com = 2, chico_injector = 1, frag_com = 2 },
  [45] = { frag = 1, dada_com = 1, copr_ability = 1, pocket_ecm_jammer = 1 },
  [60] = { sticky_grenade = 1, dynamite = 1, tag_team = 1 },
  [75] = { molotov = 1, poison_gas_grenade = 1, smoke_screen_grenade = 1 }
}

-- Fire DOT
Global.CrimDusk.weapons.fire_damage = {
  weapon_kacchainsaw_flamethrower = 0.5, weapon_money = 0.5, ammo_dragons_breath = 1, melee_spoon_gold = 0.2,
  ammo_system_low = 0.25, weapon_system = 0.5, ammo_system_high = 0.75,
  ammo_flamethrower_mk2_rare = 0.25, weapon_flamethrower_mk2 = 0.5, ammo_flamethrower_mk2_welldone = 0.75,
  proj_molotov = 1, proj_launcher_incendiary = 0.9, proj_launcher_incendiary_arbiter = 1.7, proj_fire_com = 1.2,
  proj_molotov_groundfire = 1, proj_launcher_incendiary_groundfire = 1, proj_launcher_incendiary_arbiter_groundfire = 1,
  equipment_tripmine_groundfire = 1, enemy_triad_boss_groundfire = 1, enemy_mutator_cloaker_groundfire = 1
}