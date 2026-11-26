Hooks:OverrideFunction(HUDStageEndScreen, "give_skill_points", function(self, points)
  local MaxSkillPoints, StartingPoints = 21, 1
  local PointsFromLevels = MaxSkillPoints - StartingPoints
  local LevelsPerPoint = 100 / PointsFromLevels
  if math.floor(managers.experience:current_level() % LevelsPerPoint) ~= 0 then return end

  self._num_skill_points_gained = self._num_skill_points_gained + points
  self._update_skill_points = true
end)