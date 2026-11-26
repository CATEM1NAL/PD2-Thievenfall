Hooks:PostHook(EconomyTweakData, "init", "CrimDusk_InitEconomyTweakData", function(self)
  for _, data in pairs(self.bonuses) do
    data.stats = nil
    data.exp_multiplier = nil
    data.money_multiplier = nil
  end
end)