Hooks:OverrideFunction(PlayerInventory, "get_jammer_affect", function(self)
  local upgrade_value = self._unit:base():upgrade_value("player", "pocket_ecm_jammer_base")
  local CameraSkill = self._unit:base():upgrade_value("ecm_jammer", "affects_cameras")
  local PagerSkill = self._unit:base():upgrade_value("ecm_jammer", "affects_pagers")

  return CameraSkill or false, PagerSkill or false
end)

Hooks:OverrideFunction(PlayerInventory, "get_jammer_time", function(self)
  local upgrade_value = self._unit:base():upgrade_value("player", "pocket_ecm_jammer_base")
  local DurationMult = 1 + ((self._unit:base():upgrade_value("ecm_jammer", "feedback_duration_boost") or 1) - 1) + ((self._unit:base():upgrade_value("ecm_jammer", "feedback_duration_boost_2") or 1) - 1)

  return upgrade_value and upgrade_value.duration * DurationMult or 0
end)