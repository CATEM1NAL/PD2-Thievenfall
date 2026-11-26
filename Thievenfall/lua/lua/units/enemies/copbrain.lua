-- The heists in this table are problematic and softlock if the difficulty increments mid-heist
local BrokenHeists = Global.CrimDusk.levels_no_diff_increase

local function PagerDropped(self, alarm_reason)
  -- Pagers lost scales with difficulty
  local DiffIndex = (tweak_data:difficulty_to_index(Global.game_settings.difficulty) or 2)
  local MaxPagersLost = 1 + math.floor((DiffIndex - 2) * 0.5)

  for i = 1, MaxPagersLost do managers.groupai:state():on_successful_alarm_pager_bluff() end

  -- Increment difficulty
  if not BrokenHeists[Global.game_settings.level_id] and DiffIndex < 7 then
    Global.game_settings.difficulty = tweak_data:index_to_difficulty(DiffIndex + 1)
    tweak_data:set_difficulty()
  end

  -- Exceeded pager limit; trigger alarm
  if managers.groupai:state():get_nr_successful_alarm_pager_bluffs() >= #tweak_data.player.alarm_pager.bluff_success_chance then
    managers.groupai:state():on_police_called(alarm_reason)

    self._unit:sound():stop()
    local narrator_prefix = tweak_data.levels:get_narrator_prefix()
    local sound_event = narrator_prefix .. "_alm_any_any"
    if self._unit:character_damage():dead() then self._unit:sound():corpse_play(sound_event, nil, true)
    else self._unit:sound():play(sound_event, nil, true) end
  end
end

Hooks:OverrideFunction(CopBrain, "begin_alarm_pager", function(self, reset)
  if not reset and self._alarm_pager_has_run then return end

  self._alarm_pager_has_run = true
  self._alarm_pager_data = {}
  self._alarm_pager_data.total_nr_calls = tweak_data.player.alarm_pager.nr_of_calls
  self._alarm_pager_data.nr_calls_made = 0

  local call_delay = tweak_data.player.alarm_pager.first_call_delay
  self._alarm_pager_data.pager_clbk_id = "pager" .. tostring(self._unit:key())
  managers.enemy:add_delayed_clbk(self._alarm_pager_data.pager_clbk_id, callback(self, self, "clbk_alarm_pager"), TimerManager:game():time() + call_delay)
end)

Hooks:OverrideFunction(CopBrain, "on_alarm_pager_interaction", function(self, status, player)
  if not managers.groupai:state():whisper_mode() then return end

  local is_dead = self._unit:character_damage():dead()
  local pager_data = self._alarm_pager_data
  if not pager_data then return end

  if status == "started" then
    self._unit:sound():stop()
    self._unit:interaction():set_outline_flash_state(nil, true)

    if pager_data.pager_clbk_id then
      managers.enemy:remove_delayed_clbk(pager_data.pager_clbk_id)
      pager_data.pager_clbk_id = nil
    end

  elseif status == "complete" then
    local PagersAnswered = managers.groupai:state():get_nr_successful_alarm_pager_bluffs()
    local LastPager = PagersAnswered + 1 == #tweak_data.player.alarm_pager.bluff_success_chance
    self._unit:sound():stop()

    if not LastPager then
      managers.groupai:state():on_successful_alarm_pager_bluff()
      if is_dead then self._unit:sound():corpse_play(self:_get_radio_id("dsp_radio_fooled_" .. tostring(PagersAnswered)), nil, true)
      else self._unit:sound():play(self:_get_radio_id("dsp_radio_fooled_" .. tostring(PagersAnswered)), nil, true) end

    else
      managers.groupai:state():on_police_called("alarm_pager_bluff_failed")
      self._unit:interaction():set_active(false, true)
      if is_dead then self._unit:sound():corpse_play(self:_get_radio_id("dsp_radio_alarm_1"), nil, true)
      else self._unit:sound():play(self:_get_radio_id("dsp_radio_alarm_1"), nil, true) end
    end

    self:end_alarm_pager()
    managers.mission:call_global_event("player_answer_pager")

    if not self:_chk_enable_bodybag_interaction() then self._unit:interaction():set_active(false, true) end

  elseif status == "interrupted" then
    self._unit:interaction():set_active(false, true)
    PagerDropped(self, "alarm_pager_hang_up")

    self:end_alarm_pager()
  end
end)

Hooks:OverrideFunction(CopBrain, "clbk_alarm_pager", function(self, ignore_this, data)
  local pager_data = self._alarm_pager_data
  local clbk_id = pager_data.pager_clbk_id

  pager_data.pager_clbk_id = nil
  if not managers.groupai:state():whisper_mode() then self:end_alarm_pager() return end

  -- Pager becomes active
  if pager_data.nr_calls_made == 0 then
    if managers.groupai:state():is_ecm_jammer_active("pager") then
      self:end_alarm_pager()
      self:begin_alarm_pager(true)
    return end

    self._unit:sound():stop()
    if self._unit:character_damage():dead() then self._unit:sound():corpse_play(self:_get_radio_id("dsp_radio_query_1"), nil, true)
    else self._unit:sound():play(self:_get_radio_id("dsp_radio_query_1"), nil, true) end

    self._unit:interaction():set_tweak_data("corpse_alarm_pager")
    self._unit:interaction():set_active(true, true)

  -- Pager guy tells you to pick up the pager
  elseif pager_data.nr_calls_made < pager_data.total_nr_calls then
    self._unit:sound():stop()
    if self._unit:character_damage():dead() then self._unit:sound():corpse_play(self:_get_radio_id("dsp_radio_reminder_1"), nil, true)
    else self._unit:sound():play(self:_get_radio_id("dsp_radio_reminder_1"), nil, true) end

  -- Timer expired
  elseif pager_data.nr_calls_made == pager_data.total_nr_calls then
    self._unit:interaction():set_active(false, true)
    PagerDropped(self, "alarm_pager_not_answered")

    self:end_alarm_pager()
  end

  -- Body starts flashing, timer is halfway
  if pager_data.nr_calls_made == pager_data.total_nr_calls - 1 then self._unit:interaction():set_outline_flash_state(true, true) end

  pager_data.nr_calls_made = pager_data.nr_calls_made + 1

  -- Sets timer for next pager reminder
  if pager_data.nr_calls_made <= pager_data.total_nr_calls then
    local call_delay = tweak_data.player.alarm_pager.call_duration
    self._alarm_pager_data.pager_clbk_id = clbk_id
    managers.enemy:add_delayed_clbk(self._alarm_pager_data.pager_clbk_id, callback(self, self, "clbk_alarm_pager"), TimerManager:game():time() + call_delay)
  end
end)