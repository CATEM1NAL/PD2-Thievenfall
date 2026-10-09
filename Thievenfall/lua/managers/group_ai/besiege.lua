local FileIdent = "GroupAIBesiegeManager"

Hooks:OverrideFunction(GroupAIStateBesiege, "_check_phalanx_damage_reduction_increase", function() return end)
Hooks:OverrideFunction(GroupAIStateBesiege, "set_phalanx_damage_reduction_buff", function() return end)
Hooks:PreHook(GroupAIStateBesiege, "_spawn_phalanx", "CrimDusk_GroupAISpawnPhalanx", function(self) self._phalanx_spawn_timer = false end)

Hooks:OverrideFunction(GroupAIStateBesiege, "_check_spawn_phalanx", function(self)
  if Global.CrimDusk.data.winters_dead then return end

  local AssaultBegun = self._task_data and self._task_data.assault.active and self._task_data.assault.phase == "build"
  local IsPhalanxValid = self._phalanx_center_pos and not self._phalanx_spawn_group and not self._phalanx_despawn_time and not self._phalanx_spawn_attempted
  local WintersCanSpawn = AssaultBegun and IsPhalanxValid

  if not WintersCanSpawn and not self._phalanx_spawn_timer then return

  elseif self._phalanx_spawn_timer and TimerManager:game():time() >= self._phalanx_spawn_timer then self:_spawn_phalanx() return

  elseif WintersCanSpawn then
    self._phalanx_current_spawn_chance = self._phalanx_current_spawn_chance or tweak_data.group_ai.phalanx.spawn_chance.start
    if self._phalanx_current_spawn_chance <= 0 then return end

    self._phalanx_spawn_attempted = true
    CrimDusk.Log(FileIdent, "Winters spawn chance: " .. self._phalanx_current_spawn_chance * 100 .. "%", true)

    if math.random() > self._phalanx_current_spawn_chance then return end

    CrimDusk.Log(FileIdent, "Winters is spawning!", true)
    local BuildDuration = tweak_data.group_ai.besiege.assault.build_duration
    local LowerBound = math.max(BuildDuration - 15, 0)
    self._phalanx_spawn_timer = TimerManager:game():time() + math.random(LowerBound, BuildDuration)
  end
end)

Hooks:OverrideFunction(GroupAIStateBesiege, "phalanx_damage_reduction_enable", function(self)
  managers.hud:set_buff_enabled("vip", true)

  -- Enemies spawn faster
  GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS * 8
  for CooldownType, CooldownData in pairs(tweak_data.group_ai.ai_spawn_group_cooldowns) do
    for CooldownIndex, range in ipairs(CooldownData) do
      for index, cooldown in ipairs(range) do tweak_data.group_ai.ai_spawn_group_cooldowns[CooldownType][CooldownIndex][index] = cooldown * 0.1 end
    end
  end

  -- Special spawn caps are doubled
  for index, SpawnCap in pairs(tweak_data.group_ai.special_unit_spawn_limits) do tweak_data.group_ai.special_unit_spawn_limits[index] = SpawnCap * 2 end

  -- Cloaker spawn timers increased
  for index, timer in ipairs(tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval) do
    tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval[index] = timer * 0.1
  end
  for index, timer in ipairs(tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval) do
    tweak_data.group_ai.besiege.recurring_group_SO.recurring_spawn_1.interval[index] = timer * 0.1
  end

  -- Enemy cap increased
  self._task_data.assault.force = self._task_data.assault.force * 8

  CrimDusk.Log(FileIdent, "Winters in position; spawns increased!", true)
end)

Hooks:OverrideFunction(GroupAIStateBesiege, "phalanx_damage_reduction_disable", function(self)
  managers.hud:set_buff_enabled("vip", false)

  -- Revert enemy spawn speed
  GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS = GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS * 0.125
  for CooldownType, CooldownData in pairs(tweak_data.group_ai.ai_spawn_group_cooldowns) do
    for CooldownIndex, range in ipairs(CooldownData) do
      for index, cooldown in ipairs(range) do tweak_data.group_ai.ai_spawn_group_cooldowns[CooldownType][CooldownIndex][index] = cooldown * 10 end
    end
  end

  -- Revert special spawn cap
  for index, SpawnCap in pairs(tweak_data.group_ai.special_unit_spawn_limits) do tweak_data.group_ai.special_unit_spawn_limits[index] = SpawnCap * 0.5 end

  -- Revert cloaker spawn timers
  for index, timer in ipairs(tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval) do
    tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval[index] = timer * 10
  end
  for index, timer in ipairs(tweak_data.group_ai.besiege.recurring_group_SO.recurring_cloaker_spawn.interval) do
    tweak_data.group_ai.besiege.recurring_group_SO.recurring_spawn_1.interval[index] = timer * 10
  end

  -- Revert enemy cap
  self._task_data.assault.force = self._task_data.assault.force * 0.125

  CrimDusk.Log(FileIdent, "Winters is gone; spawns reverted!", true)
end)

local BrokenHeists = { shoutout_raid = true, arena = true }

Hooks:OverrideFunction(GroupAIStateBesiege, "_begin_assault_task", function(self, assault_areas)
  local assault_task = self._task_data.assault

  if not BrokenHeists[Global.game_settings.level_id] and tweak_data:difficulty_to_index(Global.game_settings.difficulty) < 7 and not assault_task.is_first then
    local DiffIndex = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
    Global.game_settings.difficulty = tweak_data:index_to_difficulty(DiffIndex + 1)
    tweak_data:set_difficulty()
    if not managers.skirmish:is_skirmish() then NetworkHelper:SendToPeers("CrimDusk_ChangeDifficulty", Global.game_settings.difficulty) end
  end

  assault_task.active = true
  assault_task.next_dispatch_t = nil
  assault_task.target_areas = assault_areas
  assault_task.phase = "anticipation"
  assault_task.start_t = self._t

  local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.is_first)

  assault_task.is_first = nil
  assault_task.phase_end_t = self._t + anticipation_duration
  assault_task.force = math.ceil(self:_get_difficulty_dependent_value(self._tweak_data.assault.force) * self:_get_balancing_multiplier(self._tweak_data.assault.force_balance_mul))
  assault_task.use_smoke = true
  assault_task.use_smoke_timer = 0
  assault_task.use_spawn_event = true
  assault_task.force_spawned = 0

  if self._hostage_headcount > 0 then -- Each hostage increases assault delay (up to 30 seconds max)
    local hostage_delay = math.min(self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay) * self._hostage_headcount, 30)
    CrimDusk.Log(FileIdent, "Hostage delay: " .. hostage_delay, true)

    anticipation_duration = anticipation_duration + hostage_delay
    assault_task.phase_end_t = assault_task.phase_end_t + hostage_delay
    assault_task.is_hesitating = true
    assault_task.voice_delay = self._t + (assault_task.phase_end_t - self._t) / 2
  end

  self._downs_during_assault = 0

  if self._hunt_mode then assault_task.phase_end_t = 0

  else
    managers.hud:setup_anticipation(anticipation_duration)
    managers.hud:start_anticipation()
  end

  if self._draw_drama then table.insert(self._draw_drama.assault_hist, { self._t }) end

  self._task_data.recon.tasks = {}
end)

Hooks:PreHook(GroupAIStateBesiege, "_end_regroup_task", "CrimDusk_GroupAIAssaultEnd", function(self)
  if Global.CrimDusk.data["winters_dead" .. CrimDusk.IsPermadeath()] then return end

  -- Increase Winters spawn chance on assault end
  if not self._phalanx_center_pos or self._phalanx_despawn_time or self._phalanx_current_spawn_chance == 1 then return end

  local WintersChance = tweak_data.group_ai.phalanx.spawn_chance.start
  local WintersChanceIncrease = tweak_data.group_ai.phalanx.spawn_chance.increase
  local WintersChanceMax = tweak_data.group_ai.phalanx.spawn_chance.max

  self._phalanx_current_spawn_chance = math.min((self._phalanx_current_spawn_chance or WintersChance) + WintersChanceIncrease, WintersChanceMax)
  self._phalanx_spawn_attempted = false -- Reset to attempt spawn on next assault
  CrimDusk.Log(FileIdent, "Increasing Winters spawn chance! Now " .. self._phalanx_current_spawn_chance * 100 .. "%", true)
end)