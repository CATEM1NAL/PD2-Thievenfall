-- Changes to accomodate infinite levelling
Hooks:OverrideFunction(HUDStageEndScreen, "stage_experience_spin_levels", function(self, t, dt)
  local data = self._data

  if not self._playing_sound then
    self._playing_sound = true
    managers.menu_component:post_event("count_1")
  end

  self._csl = self._csl or 1

  local current_level_data = data[self._csl]

  if current_level_data then
    local total_xp = current_level_data.total
    local xp_gained_frame = dt * self._speed * math.max(total_xp * 0.08, 450)

    self._next_level_xp = self._next_level_xp - xp_gained_frame
    if self._next_level_xp <= 0 then
      xp_gained_frame = xp_gained_frame + self._next_level_xp
      self._next_level_xp = 0
    end

    self._current_xp = self._current_xp + xp_gained_frame
    self._gained_xp = self._gained_xp + xp_gained_frame
    self._speed = self._speed + dt * 1.55

    local ratio = 1 - self._next_level_xp / total_xp
    self._lp_circle:set_color(Color(ratio, 1, 1))

    if self._next_level_xp == 0 then
      self._csl = self._csl + 1

      if data[self._csl] then self._next_level_xp = data[self._csl].total
      else self._next_level_xp = false end

      self._static_current_xp = self._static_current_xp + current_level_data.total - self._static_start_xp
      self._static_gained_xp = self._static_gained_xp + current_level_data.total - self._static_start_xp
      self._current_xp = self._static_current_xp
      self._gained_xp = self._static_gained_xp
      self._static_start_xp = 0
      self._speed = math.max(1, self._speed * 0.55)

      local package_unlocked = self:level_up(current_level_data.level)

      if package_unlocked then
        self._wait_t = 0.63 + (package_unlocked.upgrades and #package_unlocked.upgrades * 0.57 or 0)
        managers.menu_component:post_event("count_1_finished")
        self._playing_sound = nil

      else self._wait_t = 0.4
        managers.menu_component:post_event("count_1_finished")
        self._playing_sound = nil
      end
    end

    local floored_gained = math.floor(self._gained_xp)

    self._experience_text_panel:child("stat"):set_text(managers.money:add_decimal_marks_to_string(tostring(self._experience_added - floored_gained)))
    self._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._current_xp))))
    self._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(floored_gained)))

    if self._next_level_xp then self._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._next_level_xp))))
    else self._lp_xp_nl:set_text("")
      self._next_level_xp = data.end_t.total
    end

  else self._speed = math.max(1.55, self._speed * 0.55)
    self._top_speed = self._speed
    self:step_stage_up()
  end
end)

Hooks:OverrideFunction(HUDStageEndScreen, "stage_experience_spin_slowdown", function(self, t, dt)
  local data = self._data
  local over100 = data.end_t.level >= 100
  local xp_gained_frame = dt * self._speed * math.max(data.end_t.total * 0.1, 450, (level_cap and self._experience_added or 0) * 0.075)
  local total_xp = data.end_t.total - data.end_t.current

  if over100 then
    if not self._endgame_setup then
      self._endgame_setup = true

      self._experience_text_panel:show()
      self._lp_xp_gained:show()
      self._lp_curr_xp:show()
      self._lp_next_level:show()

      self._lp_next_level:set_visible(true)
      self._lp_xp_nl:set_visible(true)
      self._lp_xp_gain:show()
      self._lp_xp_curr:show()
      self._lp_xp_nl:show()
      self._sum_text:hide()
      self._lp_circle:set_color(Color(1, 1, 1))
    end

    self._gained_xp = self._gained_xp + xp_gained_frame
    local countdown_xp = math.max(self._experience_added - math.floor(self._gained_xp), 0)
    self._experience_text_panel:child("stat"):set_text(managers.money:add_decimal_marks_to_string(tostring(countdown_xp)))
    self._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._gained_xp))))

    self._next_level_xp = total_xp

    if self._next_level_prestige_xp < managers.experience:get_current_prestige_xp() then
      self._next_level_prestige_xp = self._next_level_prestige_xp + xp_gained_frame
      local ratio = self._next_level_prestige_xp / managers.experience:get_max_prestige_xp()
      self._prestige_lp_circle:set_color(Color(ratio, 1, 1))

    elseif countdown_xp == 0 then
      WalletGuiObject.refresh()
      self._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._experience_added))))
      self:step_stage_up()
    end
  end

  self._next_level_xp = self._next_level_xp - xp_gained_frame

  if total_xp > self._next_level_xp then
    WalletGuiObject.refresh()

    xp_gained_frame = xp_gained_frame + (self._next_level_xp - total_xp)
    self._next_level_xp = total_xp

    self:step_stage_up()
  end

  xp_gained_frame = math.min(xp_gained_frame, self._next_level_xp)
  self._current_xp = self._current_xp + xp_gained_frame
  self._gained_xp = self._gained_xp + xp_gained_frame

  if data.end_t.current ~= 0 then
    self._top_speed = self._top_speed or 1

    local ex = (data.end_t.total - self._next_level_xp) / data.end_t.current
    self._speed = math.max(1, self._top_speed / (self._top_speed * 2)^ex)
  end

  local ratio = 1 - self._next_level_xp / data.end_t.total

  self._lp_circle:set_color(Color(ratio, 1, 1))

  local floored_gained = math.max(math.floor(self._gained_xp), 0)
  self._experience_text_panel:child("stat"):set_text(managers.money:add_decimal_marks_to_string(tostring(self._experience_added - floored_gained)))
  self._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._current_xp))))
  self._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(floored_gained)))
  self._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._next_level_xp))))
end)

Hooks:OverrideFunction(HUDStageEndScreen, "stage_experience_end", function(self, t, dt)
  local data = self._data
  local ratio = data.end_t.current / data.end_t.total

  self._static_current_xp = data.end_t.xp
  self._static_gained_xp = data.gained
  self._current_xp = self._static_current_xp
  self._gained_xp = self._static_gained_xp

  local floored_gained = math.floor(self._gained_xp)
  self._experience_text_panel:child("stat"):set_text(managers.money:add_decimal_marks_to_string(tostring(self._experience_added - floored_gained)))
  self._experience_text_panel:hide()
  self._lp_xp_curr:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(self._current_xp))))
  self._lp_xp_gain:set_text(managers.money:add_decimal_marks_to_string(tostring(floored_gained)))
  self._lp_circle:set_color(Color(ratio, 1, 1))
  self._lp_xp_nl:set_text(managers.money:add_decimal_marks_to_string(tostring(math.floor(data.end_t.total - data.end_t.current))))

  managers.menu_component:post_event("count_1_finished")
  self:step_stage_up()
end)

Hooks:OverrideFunction(HUDStageEndScreen, "give_skill_points", function(self, points)
  local MaxSkillPoints, StartingPoints = 21, 1
  local PointsFromLevels = MaxSkillPoints - StartingPoints
  local LevelsPerPoint = 100 / PointsFromLevels
  if math.floor(managers.experience:current_level() % LevelsPerPoint) ~= 0 then return end

  self._num_skill_points_gained = self._num_skill_points_gained + points
  self._update_skill_points = true
end)