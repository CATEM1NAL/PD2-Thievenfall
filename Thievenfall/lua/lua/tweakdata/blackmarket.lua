Hooks:PostHook(BlackMarketTweakData, "_init_characters", "CrimDusk_InitCharBMTweak", function(self)
  self.characters.wild.dlc = "wild_char"
  self.characters.locked.old_hoxton.locks = nil
  self.characters.locked.old_hoxton.global_value = "freed_old_hoxton"
end)

Hooks:PostHook(BlackMarketTweakData, "_init_deployables", "CrimDusk_InitDeployablesBMTweak", function(self)
  self.deployables.grenade_crate = nil
  self.deployables.sentry_gun_silent = nil
  self.deployables.armor_kit = nil
end)