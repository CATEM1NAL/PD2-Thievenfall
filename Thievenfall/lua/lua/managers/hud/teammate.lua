Hooks:OverrideFunction(HUDTeammate, "set_revives_amount", function(self, revive_amount)
  if revive_amount then
    local teammate_panel = self._panel:child("player")
    local revive_panel = teammate_panel:child("revive_panel")
    local revive_amount_text = revive_panel:child("revive_amount")
    local revive_bg = revive_panel:child("revive_bg")

    if revive_amount_text then revive_amount_text:set_text(tostring(math.max(revive_amount - 1, 0))) end
    if revive_bg then revive_bg:set_color(tweak_data.hud.revive_colors[revive_amount] or tweak_data.hud.revive_colors[4]) end
  end
end)