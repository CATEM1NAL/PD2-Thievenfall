local FileIdent = "GagePackageManager"

Hooks:OverrideFunction(GageAssignmentManager, "_give_rewards", function(self, assignment)
  local completed = Application:digest_value(self._global.completed_assignments[assignment], false) + 1
  self._global.completed_assignments[assignment] = Application:digest_value(completed, true)

  local coins = self._tweak_data:get_value(assignment, "coins")
  CrimDusk.Log(FileIdent, "Gained " .. coins .. " from Gage Assignment", true)
  if coins then managers.custom_safehouse:add_coins(coins, TelemetryConst.economy_origin.job_reward) end

  local award_gmod_6 = true
  for i, dvalue in pairs(self._global.completed_assignments) do
    if Application:digest_value(dvalue, false) < tweak_data.achievement.gonna_find_them_all then award_gmod_6 = false break end
  end

  if award_gmod_6 then managers.achievment:award("gmod_6") end
end)