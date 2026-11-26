Hooks:PostHook(LevelsTweakData, "init", "CrimDusk_LevelTweakInit", function(self)
  -- Tutorial loadouts are unforced
  self.short1_stage1.force_equipment = nil
  self.short1_stage1.disable_mutators = nil

  self.short1_stage2.force_equipment = nil
  self.short1_stage2.disable_mutators = nil

  self.short2_stage1.force_equipment = nil
  self.short2_stage1.disable_mutators = nil

  for heist, data in pairs(Global.CrimDusk.heists) do
    self[heist].ghost_bonus = Global.CrimDusk.stealth_bonuses[data.bonus]
    self[heist].env_params = self[heist].env_params or {}
    self[heist].env_params.color_grading = data.grading
    self[heist].player_style = data.suit or self[heist].player_style
  end
end)