Hooks:PostHook(GageAssignmentTweakData, "init", "CrimDawn_InitGagePackageTweak", function(self)
  self.NUM_ASSIGNMENT_UNITS = { 2, 3, 4, 5, 6, 7, 8 }
  self.EXPERIENCE_MULTIPLIER = 0.1

  local PackageCoins = { green_mantis = 1, yellow_bull = 2, red_spider = 3, blue_eagle = 4, purple_snake = 5 }
  for package, _ in pairs(self.assignments) do self.assignments[package].coins = PackageCoins[package] end
end)