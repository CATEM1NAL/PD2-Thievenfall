Hooks:PostHook(BlackMarketTweakData, "_init_projectiles", "CrimDusk_ProjectileTweakInit", function(self, tweak_data)
  self.projectiles.wpn_prj_ace.max_amount = 1
  self.projectiles.chico_injector.dlc = nil

  for regen, category in pairs(Global.CrimDusk.weapons.throwables) do
    for weapon, count in pairs(category) do
      self.projectiles[weapon].base_cooldown = regen
      self.projectiles[weapon].max_amount = count
      self.projectiles[weapon].ignore_auto_equip = true
    end
  end
end)