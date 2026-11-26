Hooks:OverrideFunction(CrewManagementGui, "populate_skill", function(self, params, data, gui)
  local category, henchman_index = unpack(params)
  local crew_skills = { "crew_motivated", "crew_evasive", "crew_quiet", "crew_eager" }
  self:populate_custom(category, henchman_index, tweak_data.upgrades.crew_skill_definitions, crew_skills, data, gui)
end)

Hooks:OverrideFunction(CrewManagementGui, "populate_ability", function(self, henchman_index, data, gui)
  local crew_abilities = { "crew_inspire", "crew_ai_flashbang", "crew_ai_counter_strike", "crew_ai_counter_tase" }
  self:populate_custom("ability", henchman_index, tweak_data.upgrades.crew_ability_definitions, crew_abilities, data, gui)
end)