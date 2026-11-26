Hooks:PostHook(InfamyTreeGui, "_setup", "CrimDusk_SetupInfamyTreeGUI", function(self)
  self.infamous_panel:child("infamy_panel_bottom"):child("go_infamous_button"):child("go_infamous_rep_panel"):hide()
  self._can_go_infamous = false

  local IsMaxLevel = managers.experience:current_level() >= 100
  local InfamyPoolFilled = managers.experience:get_current_prestige_xp() >= managers.experience:get_max_prestige_xp()
  local InfamyLevelAvailable = managers.experience:current_rank() < tweak_data.infamy.ranks

  if IsMaxLevel and InfamyPoolFilled and InfamyLevelAvailable then self._can_go_infamous_prestige = true end
end)