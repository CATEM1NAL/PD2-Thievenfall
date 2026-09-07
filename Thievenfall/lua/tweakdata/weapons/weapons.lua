local FileIdent = "WeaponTweakData"

local function SetAIStats(self)
  -- Health (vanilla OVK)
  self.swat_van_turret_module.HEALTH_INIT = 15000
  self.swat_van_turret_module.SHIELD_HEALTH_INIT = 500
  self.ceiling_turret_module.HEALTH_INIT = 10000
  self.ceiling_turret_module.SHIELD_HEALTH_INIT = 250
  self.aa_turret_module.HEALTH_INIT = 15000
  self.aa_turret_module.SHIELD_HEALTH_INIT = 500
  self.crate_turret_module.HEALTH_INIT = 10000
  self.crate_turret_module.SHIELD_HEALTH_INIT = 500

  -- Damage (vanilla Hard)
  self.ak47_ass_npc.DAMAGE = 0.4
  self.ak47_npc.DAMAGE = 0.5
  self.m4_npc.DAMAGE = 0.4
  self.m4_yellow_npc.DAMAGE = 0.4
  self.g36_npc.DAMAGE = 0.6

  self.r870_npc.DAMAGE = 1
  self.benelli_npc.DAMAGE = 1

  self.smoke_npc.DAMAGE = 0.6

  -- Turret damage adjustments
  self.swat_van_turret_module.DAMAGE = 0.05
  self.ceiling_turret_module.DAMAGE = 0.05
  self.aa_turret_module.DAMAGE = 0.05
  self.crate_turret_module.DAMAGE = 0.05

  -- Dozers
  self.mossberg_npc.DAMAGE = 2
  self.saiga_npc.DAMAGE = 1
  self.m249_npc.DAMAGE = 0.25
  self.rpk_lmg_npc.DAMAGE = 0.25
  self.mini_npc.DAMAGE = 0.1

  -- Bosses
  self.hk21_npc.DAMAGE = 0.5
  self.contraband_npc.DAMAGE = 0.6
  self.flamethrower_npc.DAMAGE = 0.05

  -- Other damage adjustments
  self.npc_melee.baton.damage = 5
  self.npc_melee.knife_1.damage = 10
  self.npc_melee.fists.damage = 2.5

  self.c45_npc.DAMAGE = 0.5
  self.colt_1911_primary_npc.DAMAGE = 0.5
  self.glock_18_npc.DAMAGE = 0.5

  self.raging_bull_npc.DAMAGE = 2.5

  self.mp5_npc.DAMAGE = 0.25
  self.mp5_tactical_npc.DAMAGE = 0.25
  self.ump_npc.DAMAGE = 0.25
  self.akmsu_smg_npc.DAMAGE = 0.25
  self.asval_smg_npc.DAMAGE = 0.25

  self.mac11_npc.DAMAGE = 0.25

  self.mp9_npc.DAMAGE = 0.25
  self.sr2_smg_npc.DAMAGE = 0.25

  self.m14_npc.DAMAGE = 2.5
  self.s552_npc.DAMAGE = 0.6
  self.scar_npc.DAMAGE = 1

  self.m14_sniper_npc.trail = "effects/particles/weapons/sniper_trail"
  self.svd_snp_npc.trail = "effects/particles/weapons/sniper_trail"
  self.svdsil_snp_npc.trail = "effects/particles/weapons/sniper_trail"

  self.heavy_snp_npc.DAMAGE = 5 -- ZEAL sniper
  self.heavy_snp_npc.trail = "effects/particles/weapons/sniper_trail_marshal"

  self.dmr_npc.DAMAGE = 2.5 -- Marshal sniper
end

Hooks:OverrideFunction(WeaponTweakData, "_set_normal", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_hard", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_overkill", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_overkill_145", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_easy_wish", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_overkill_290", function(self) SetAIStats(self) end)
Hooks:OverrideFunction(WeaponTweakData, "_set_sm_wish", function(self) SetAIStats(self) end)

local WeaponClasses = Global.CrimDusk.weapons.classes
local WeaponDamage = Global.CrimDusk.weapons.damage
local SpreadMults = Global.CrimDusk.weapons.spread
local AmmoPickup = Global.CrimDusk.weapons.pickup
local MaxMagazines = Global.CrimDusk.weapons.magazines
local AkimboOverride = Global.CrimDusk.weapons.akimbo
local CrewNameConversion = Global.CrimDusk.weapons.crew
local APTypes = Global.CrimDusk.weapons.ap

local function ModifyStats(self, WeaponClassName, WeaponClassData)
  for Weapon, Data in pairs(WeaponClassData) do
    local Akimbo = self["x_" .. Weapon]

    -- Global changes to account for index tweaks
    self[Weapon].stats.extra_ammo = self[Weapon].stats.extra_ammo + 50
    if Akimbo then Akimbo.stats.extra_ammo = Akimbo.stats.extra_ammo + 50 end

    self[Weapon].stats.reload = self[Weapon].stats.reload + 5
    if Akimbo then Akimbo.stats.reload = Akimbo.stats.reload + 5 end

    -- Custom stat initialisation
    self[Weapon].MagDump = Data.magdump == nil and true or Data.magdump
    if Akimbo then Akimbo.MagDump = Data.magdump == nil and true or Data.magdump end

    self[Weapon].ChamberRounds = Data.chamber or 1
    if Akimbo then Akimbo.ChamberRounds = (Data.chamber or 1) * 2 end

    -- Pre-set some stats
    if self[Weapon].stats_modifiers and self[Weapon].stats_modifiers.damage then
      self[Weapon].stats_modifiers.damage = Data.dmgmult or self[Weapon].stats_modifiers.damage
    end

    local PickupChanged
    if Data.pickup then
      if type(Data.pickup) == "string" then Data.pickup = AmmoPickup[Data.pickup] end
      self[Weapon].AMMO_PICKUP = Data.pickup
      if Akimbo then Akimbo.AMMO_PICKUP = Data.pickup end
      PickupChanged = true
    end

    for Stat, Value in pairs(Data) do -- Apply custom stat overrides

      if Stat == "dmg" then -- Damage
        if type(Value) == "string" then Value = WeaponDamage[WeaponClassName][Value] end
        local DmgMult = self[Weapon].stats_modifiers and self[Weapon].stats_modifiers.damage or 1
        local Pellets = self[Weapon].rays and self[Weapon].rays or 1
        local MaxDamage = Value * DmgMult * Pellets

        -- Player damage
        self[Weapon].stats.damage = Value
        if Akimbo then Akimbo.stats.damage = Value end
        
        -- Team AI damage
        if self[Weapon .. "_crew"] then self[Weapon .. "_crew"].DAMAGE = Value * DmgMult * 0.5
        elseif self[CrewNameConversion[Weapon]] then self[CrewNameConversion[Weapon]].DAMAGE = Value * DmgMult * 0.5 end

        if not PickupChanged then -- Ammo pickup
          local PickupMod = 75 / MaxDamage
          local MostShotsToKill = math.max(150 / (MaxDamage * 2) + (PickupMod^2), 0.5 + PickupMod)
          local LeastShotsToKill = math.max(200 / (MaxDamage * 2.625) - 0.5, 0.5 * PickupMod)

          self[Weapon].AMMO_PICKUP = { LeastShotsToKill, MostShotsToKill }
          if Akimbo then Akimbo.AMMO_PICKUP = { LeastShotsToKill, MostShotsToKill } end
        end

      elseif Stat == "acc" then -- Accuracy
        self[Weapon].stats.spread = Value
        self[Weapon].stats.spread_moving = Value

        if Akimbo or AkimboOverride[Weapon] then
          local Weapon = Akimbo and ("x_" .. Weapon) or Weapon
          self[Weapon].stats.spread = math.max(math.floor(Value * 0.5), 1)
          self[Weapon].stats.spread_moving = self[Weapon].stats.spread
        end

      elseif Stat == "stab" then -- Stability
        self[Weapon].stats.recoil = Value
        if Akimbo then Akimbo.stats.recoil = Value end

      elseif Stat == "mag" then -- Magazine size
        if self[Weapon .. "_crew"] then self[Weapon .. "_crew"].CLIP_AMMO_MAX = Value
        elseif self[CrewNameConversion[Weapon]] then self[CrewNameConversion[Weapon]].CLIP_AMMO_MAX = Value end

        self[Weapon].CLIP_AMMO_MAX = Value
        if Akimbo then Akimbo.CLIP_AMMO_MAX = Value end

      elseif Stat == "reload" then -- Reload speed
        self[Weapon].stats.reload = Value

      elseif Stat == "rof" then -- Fire rate
        self[Weapon].fire_mode_data.fire_rate = 60 / Value
        if self[Weapon].single then self[Weapon].single.fire_rate = 60 / Value end
        if self[Weapon].auto then self[Weapon].auto.fire_rate = 60 / Value end
      end
    end

    -- Set weapon's AP parameters
    self[Weapon].has_description = APTypes[Data.ap] and true or nil
    self[Weapon].armor_piercing_chance = APTypes[Data.ap] and APTypes[Data.ap].ap or nil
    self[Weapon].can_shoot_through_enemy = APTypes[Data.ap] and APTypes[Data.ap].enemy or nil
    self[Weapon].can_shoot_through_shield = APTypes[Data.ap] and APTypes[Data.ap].shield or nil
    self[Weapon].can_shoot_through_wall = APTypes[Data.ap] and APTypes[Data.ap].wall or nil

    if Akimbo then
      Akimbo.has_description = APTypes[Data.ap] and true or nil
      Akimbo.armor_piercing_chance = APTypes[Data.ap] and APTypes[Data.ap].ap or nil
      Akimbo.can_shoot_through_enemy = APTypes[Data.ap] and APTypes[Data.ap].enemy or nil
      Akimbo.can_shoot_through_shield = APTypes[Data.ap] and APTypes[Data.ap].shield or nil
      Akimbo.can_shoot_through_wall = APTypes[Data.ap] and APTypes[Data.ap].wall or nil
    end

    -- Stats derived from weapon class
    local NumMagazines = Data.nummags or MaxMagazines[WeaponClassName]
    self[Weapon].AMMO_MAX = self[Weapon].CLIP_AMMO_MAX * NumMagazines
    if Akimbo then Akimbo.AMMO_MAX = Akimbo.CLIP_AMMO_MAX * NumMagazines end
    self[Weapon].spread = SpreadMults[WeaponClassName]
  end
end

Hooks:PostHook(WeaponTweakData, "init", "CrimDusk_WeaponTweakInit", function(self)
  -- Update stat indexes
  self.stats.reload = {}
  for i = -5, 20 do table.insert(self.stats.reload, i / 10) end

  self.stats.extra_ammo = {}
  for i = -100, 100 do table.insert(self.stats.extra_ammo, i) end

  self.stats.spread = {}
  for i = 0, 25 do table.insert(self.stats.spread, 3 - (i * 0.1)) end

  self.stats.spread_moving = {}
  for i = 0, 25 do table.insert(self.stats.spread_moving, 5 - (i * 0.1)) end

  -- Update weapon damage
  self.trip_mines.damage = 15
  for WeaponClassName, WeaponClassData in pairs(WeaponClasses) do ModifyStats(self, WeaponClassName, WeaponClassData) end

  -- Category changes
  self.hailstorm.categories = { "assault_rifle" }
  self.hajk.categories = { "assault_rifle" }
  self.x_hajk.categories = {}
  self.ching.categories = { "snp" }
  self.hajk.use_data.selection_index = 2
  self.scout.use_data.selection_index = 2
  self.victor.use_data.selection_index = 2
  self.rpg7.use_data.selection_index = 2
  self.ray.use_data.selection_index = 2

  -- Attribute tweaks
  self.welrod.stats_modifiers = nil
  self.maxim9.do_shotgun_push = nil
  self.bessy.special_damage_multiplier = 60
end)