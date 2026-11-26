Hooks:OverrideFunction(NewSkillTreeGui, "_update_description", function(self, item)
  local desc_panel = self._panel:child("InfoRootPanel"):child("DescriptionPanel")
	local text = desc_panel:child("DescriptionText")
	local tier = item:tier()
	local skill_id = item:skill_id()
	local tweak_data_skill = tweak_data.skilltree.skills[skill_id]
	local skill_stat_color = tweak_data.screen_colors.resource
	local color_replace_table = {}
	local points = self._skilltree:points() or 0
	local costs = {
	  lv1 = self._skilltree:get_skill_points(skill_id, 1) or 0,
	  lv2 = self._skilltree:get_skill_points(skill_id, 2) or 0,
	  lv3 = self._skilltree:get_skill_points(skill_id, 3) or 0,
	  lv4 = self._skilltree:get_skill_points(skill_id, 4) or 0
	}
	local talent = tweak_data.skilltree.skills[skill_id]
	local unlocked = self._skilltree:skill_unlocked(nil, skill_id)
	local step = self._skilltree:next_skill_step(skill_id)
	local completed = self._skilltree:skill_completed(skill_id)
	local skill_descs = tweak_data.upgrades.skill_descs[skill_id] or { 0, 0 }
	local basic_color_index = 1
	local pro_color_index = 2 + (skill_descs[1] or 0)

  local HighestLevel = 4
  for i = 1, HighestLevel do
    if step > i then
      costs["lv" .. i] = "LEVEL " .. i .. ": ##" .. utf8.to_upper(managers.localization:text("st_menu_skill_owned")) .. "##\n"
      color_replace_table[basic_color_index] = tweak_data.screen_colors.resource
    else
      costs["lv" .. i] = "LEVEL " .. i .. ": ##" .. managers.localization:text(costs["lv" .. i] == 1 and "st_menu_point"
                          or "st_menu_point_plural", { points = costs["lv" .. i] }) .. "##\n"
    end
  end

  local macroes = { lv1 = costs.lv1, lv2 = costs.lv2, lv3 = costs.lv3, lv4 = costs.lv4 }

	local skill_string = managers.localization:to_upper_text(tweak_data_skill.name_id)
	local desc_string = managers.localization:text(tweak_data.skilltree.skills[skill_id].desc_id, macroes)
	local full_string = skill_string .. "\n\n" .. desc_string

	text:set_text(full_string)
	managers.menu_component:make_color_text(text)
	text:set_font_size(tweak_data.menu.pd2_small_font_size)

	local _, _, _, h = text:text_rect()

	while h > desc_panel:h() - text:top() do
		text:set_font_size(text:font_size() * 0.98)

		_, _, _, h = text:text_rect()
	end
end)