Hooks:PostHook(PrePlanningTweakData, "init", "CrimDusk_InitPreplanTweak", function(self)
  -- Disable grenade case
  self.types.grenade_crate.total = 0
  self.types.grenade_crate.prio = 0

  self.categories.insider_help.upgrade_lock = nil
  for _, asset in pairs(self.types) do asset.upgrade_lock = nil end
end)