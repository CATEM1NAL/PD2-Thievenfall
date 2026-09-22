Hooks:PostHook(BlackMarketTweakData, "_init_melee_weapons", "CrimDusk_InitMeleeTweakData", function(self)
  -- Hide weapon butt
  self.melee_weapons.weapon.dlc = "crimdusk_hidden_item"
  self.melee_weapons.weapon.repeat_expire_t = 0.5

  self.melee_weapons.toothbrush.dlc = "freed_old_hoxton"
  self.melee_weapons.toothbrush.locks = nil

  -- Main tweakdata changes
  local MeleeClasses = Global.CrimDusk.melee.classes
  local MeleeStats = Global.CrimDusk.melee.stats
  local ResetTimers = Global.CrimDusk.melee.reset
  local EquipTimers = Global.CrimDusk.melee.equip

  for MeleeClass, MeleeClassData in pairs(MeleeClasses) do
    for MeleeWeapon, MeleeData in pairs(MeleeClassData) do
      local Range = self.melee_weapons[MeleeWeapon].stats.range
      local Conceal = self.melee_weapons[MeleeWeapon].stats.concealment

      self.melee_weapons[MeleeWeapon].stats = MeleeStats[MeleeClass]
      self.melee_weapons[MeleeWeapon].stats.range = Range
      self.melee_weapons[MeleeWeapon].stats.concealment = Conceal
      self.melee_weapons[MeleeWeapon].stats.remove_weapon_movement_penalty = true

      local RepTimeChanged, EquipTimeChanged
      for Stat, Value in pairs(MeleeData) do
        if Stat == "rep" then
          self.melee_weapons[MeleeWeapon].repeat_expire_t = Value
          self.melee_weapons[MeleeWeapon].expire_t = Value
          RepTimeChanged = true

        elseif Stat == "equip" then
          self.melee_weapons[MeleeWeapon].attack_allowed_expire_t = Value
          EquipTimeChanged = true

        elseif Stat == "anim" then
          self.melee_weapons[MeleeWeapon].anim_global_param = Value
          self.melee_weapons[MeleeWeapon].expire_t = ResetTimers[Value]
          self.melee_weapons[MeleeWeapon].melee_damage_delay = Global.CrimDusk.melee.damage_delay[Value]

        elseif Stat == "dismember" then self.melee_weapons[MeleeWeapon].dismember = Value end
      end

      local AnimSet = self.melee_weapons[MeleeWeapon].anim_global_param

      if not RepTimeChanged and ResetTimers[AnimSet] then
        self.melee_weapons[MeleeWeapon].repeat_expire_t = ResetTimers[AnimSet]
        self.melee_weapons[MeleeWeapon].expire_t = ResetTimers[AnimSet]
      end

      if not EquipTimeChanged and EquipTimers[AnimSet] then
        self.melee_weapons[MeleeWeapon].attack_allowed_expire_t = EquipTimers[AnimSet]
      
      elseif not EquipTimeChanged then
        self.melee_weapons[MeleeWeapon].attack_allowed_expire_t = self.melee_weapons[MeleeWeapon].repeat_expire_t
      end
    end
  end

  -- Animation tweaks for dismembering weapons (weapon swings sideways)
  self.melee_weapons.cs.anim_attack_vars = { "var1", "var2", "var3" }
  self.melee_weapons.beardy.anim_attack_vars = { "var1" }
  self.melee_weapons.great.anim_attack_vars = { "var1", "var2" }
  self.melee_weapons.fireaxe.anim_attack_vars = { "var1", "var4" }
  self.melee_weapons.cleaver.anim_attack_vars = { "var1", "var2", "var4" }

  local MacheteAnims = { "machete", "gator", "oxide" }
  for _, weapon in ipairs(MacheteAnims) do self.melee_weapons[weapon].anim_attack_vars = { "var1", "var3" } end

  local AxeAnims = { "scalper", "tomahawk", "meat_cleaver", "becker" }
  for _, weapon in ipairs(AxeAnims) do self.melee_weapons[weapon].anim_attack_vars = { "var2", "var3" } end
end)