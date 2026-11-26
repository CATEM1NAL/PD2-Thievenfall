local FileIdent = "GroupAIBaseManager"

Hooks:OverrideFunction(GroupAIStateBase, "has_room_for_police_hostage", function(self)
  local DominatorSkill = managers.player:has_category_upgrade("player", "assault_intimidate")
  local AssaultActive = self._task_data and self._task_data.assault.phase and self._task_data.assault.phase ~= "anticipation"
  local CanDominate = AssaultActive and DominatorSkill or not AssaultActive
  --CrimDusk.Log(FileIdent, "CanDominate: " .. tostring(CanDominate), true)
  if not CanDominate then return false end

  local HostagesAllowed = 0
  for _, _ in pairs(self._player_criminals) do HostagesAllowed = HostagesAllowed + 1 end
  --CrimDusk.Log(FileIdent, "HostagesAllowed: " .. tostring(HostagesAllowed), true)
  return HostagesAllowed > self._police_hostage_headcount
end)