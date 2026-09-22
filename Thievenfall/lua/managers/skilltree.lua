SkillTreeManager.VERSION = 20

Hooks:PreHook(SkillTreeManager, "_setup", "CrimDusk_SkillTreeManagerSetup", function(self)
  self.StartingPoints = 1 -- How many points the player has at Level 0
  self.MaxSkillPoints = 21 -- How many skill points the player has at Level 100
  self.MaxInfamyPoints = 4 -- How many extra skill points the player has at Infamy 52

  self.LevelsPerPoint = 100 / (self.MaxSkillPoints - self.StartingPoints) -- Spread skill points evenly across levels
  self.InfamiesPerPoint = 52 / self.MaxInfamyPoints -- Spread infamy points evenly
end)

Hooks:OverrideFunction(SkillTreeManager, "skill_cost", function(self, tier) return tier end)
Hooks:OverrideFunction(SkillTreeManager, "level_up", function(self)
  local CurrentLevel = managers.experience:current_level()
  if CurrentLevel < 100 and CurrentLevel % self.LevelsPerPoint == 0 then self:_aquire_points(1)
  elseif CurrentLevel == 100 and self:points() ~= self.MaxSkillPoints then self:_aquire_points(self.MaxSkillPoints - self:points()) end
end)

Hooks:OverrideFunction(SkillTreeManager, "_setup_skill_switches", function(self)
  if not self._global.skill_switches then
    self._global.skill_switches = {}

    for i = 1, #tweak_data.skilltree.skill_switches do
      self._global.skill_switches[i] = {
        specialization = false,
        unlocked = i == 1,
        points = Application:digest_value(self.StartingPoints, true)
      }

      local switch_data = self._global.skill_switches[i]
      switch_data.trees = {}
      for tree, data in pairs(tweak_data.skilltree.trees) do
        switch_data.trees[tree] = { unlocked = true, points_spent = Application:digest_value(0, true) }
      end

      switch_data.skills = {}
      for skill_id, data in pairs(tweak_data.skilltree.skills) do
        switch_data.skills[skill_id] = { unlocked = 0, total = #data }
      end
    end

  else
    for i = 1, #tweak_data.skilltree.skill_switches do
      local switch_data = self._global.skill_switches[i]

      switch_data.trees = {}
      for tree, data in pairs(tweak_data.skilltree.trees) do
        switch_data.trees[tree] = { unlocked = true, points_spent = Application:digest_value(0, true) }
      end

      switch_data.skills = {}
      for skill_id, data in pairs(tweak_data.skilltree.skills) do
        switch_data.skills[skill_id] = { unlocked = 0, total = #data }
      end

    end
  end
end)

Hooks:OverrideFunction(SkillTreeManager, "_verify_loaded_data", function(self)
  for i, switch_data in ipairs(self._global.skill_switches) do
    local SkillPoints = self.StartingPoints + math.floor(managers.experience:current_level() / self.LevelsPerPoint)
    SkillPoints = math.min(SkillPoints, self.MaxSkillPoints)

    local InfamyPoints = math.floor(managers.experience:current_rank() / self.InfamiesPerPoint)
    InfamyPoints = math.min(InfamyPoints, self.MaxInfamyPoints)

    local TotalPoints = SkillPoints + InfamyPoints

    for skill_id, data in pairs(clone(switch_data.skills)) do
      if not tweak_data.skilltree.skills[skill_id] then switch_data.skills[skill_id] = nil end
    end

    for tree_id, data in pairs(clone(switch_data.trees)) do
      if not tweak_data.skilltree.trees[tree_id] then switch_data.trees[tree_id] = nil end
    end

    for tree_id, data in pairs(clone(switch_data.trees)) do
      local points_spent = math.max(Application:digest_value(data.points_spent, false), 0)
      data.points_spent = Application:digest_value(points_spent, true)
      TotalPoints = TotalPoints - points_spent
    end

    local unlocked = self:trees_unlocked(switch_data.trees)
    while unlocked > 0 do unlocked = unlocked - 1 end

    switch_data.points = Application:digest_value(TotalPoints, true)
  end

  for i = 1, #self._global.skill_switches do
    if self._global.skill_switches[i] and Application:digest_value(self._global.skill_switches[i].points or 0, false) < 0 then
      local switch_data = self._global.skill_switches[i]

      if self._global.skill_switches[self._global.selected_skill_switch] and self._global.skill_switches[self._global.selected_skill_switch] == switch_data then
        self._global.selected_skill_switch = 1
      end

      switch_data.points = Application:digest_value(0, true)
    end
  end

  if not self._global.skill_switches[self._global.selected_skill_switch] then self._global.selected_skill_switch = 1 end

  local data = self._global.skill_switches[self._global.selected_skill_switch]
  self._global.points = data.points
  self._global.trees = data.trees
  self._global.skills = data.skills

  for tree_id, tree_data in pairs(self._global.trees) do
    if tree_data.unlocked and not tweak_data.skilltree.trees[tree_id].dlc then
      for tier, skills in pairs(tweak_data.skilltree.trees[tree_id].tiers) do
        for _, skill_id in ipairs(skills) do
          local skill = tweak_data.skilltree.skills[skill_id]
          local skill_data = self._global.skills[skill_id]

          for i = 1, skill_data.unlocked do self:_aquire_skill(skill[i], skill_id, true) end
        end
      end
    end
  end
end)

Hooks:OverrideFunction(SkillTreeManager, "max_points_for_current_level", function(self)
  local SkillPoints = self.StartingPoints + math.floor(managers.experience:current_level() / self.LevelsPerPoint)
  SkillPoints = math.min(SkillPoints, self.MaxSkillPoints)

  local InfamyPoints = math.floor(managers.experience:current_rank() / self.InfamiesPerPoint)
  InfamyPoints = math.min(InfamyPoints, self.MaxInfamyPoints)

  return SkillPoints + InfamyPoints
end)