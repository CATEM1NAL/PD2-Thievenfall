Hooks:OverrideFunction(ExperienceManager, "_set_next_level_data", function(self, level)
  local LevelIndex = level

  if level > 100 then LevelIndex = 100 end
  local LevelDelta = level - LevelIndex
  local LevelData = tweak_data.experience_manager.levels[LevelIndex]

  self._global.next_level_data = {}

  self:_set_next_level_data_points(LevelData.points)
  self:_set_next_level_data_current_points(0)

  if self._experience_progress_data then table.insert(self._experience_progress_data, { level = level, current = 0, total = self:next_level_data_points() }) end
end)

Hooks:OverrideFunction(ExperienceManager, "_level_up", function(self)
  self:_set_current_level(self:current_level() + 1)
  self:_set_next_level_data(self:current_level() + 1)

  self:_check_achievements()

  if managers.network:session() then managers.network:session():send_to_peers_synched("sync_level_up", self:current_level()) end

  if self:current_level() <= 100 then
    managers.upgrades:level_up()
    managers.skilltree:level_up()
  end

  managers.mission:call_global_event(Message.OnLevelUp)
end)

Hooks:OverrideFunction(ExperienceManager, "add_points", function(self, points, present_xp, NoPool)
  if points <= 0 then return end

  if not NoPool and self:current_level() >= self:level_cap() then
    self:set_current_prestige_xp(self:get_current_prestige_xp() + points)
  end

  if present_xp then self:_present_xp(points) end

  local PointsToNext = self:next_level_data_points() - self:next_level_data_current_points()
  if points < PointsToNext then
    self:_set_total(self:total() + points)
    self:_set_xp_gained(self:total())
    self:_set_next_level_data_current_points(self:next_level_data_current_points() + points)
    self:present()
    managers.statistics:aquired_money(points)
  return end

  self:_set_total(self:total() + PointsToNext)
  self:_set_xp_gained(self:total())
  self:_set_next_level_data_current_points(self:next_level_data_current_points() + PointsToNext)
  self:present()
  self:_level_up()
  managers.statistics:aquired_money(PointsToNext)

  return self:add_points(points - PointsToNext, present_xp, true)
end)

-- Infamy every 13th, not 13+1 (why the fuck is it like that)
Hooks:OverrideFunction(ExperienceManager, "rank_icon", function(self, rank)
  if rank and rank > 0 then
    local index = math.min(math.floor(rank / tweak_data.infamy.icon_rank_step) + 1, #tweak_data.infamy.infamy_icons)
    return (tweak_data.infamy.infamy_icons[index] or tweak_data.infamy.infamy_icons[1]).hud_icon
  end
end)

Hooks:OverrideFunction(ExperienceManager, "rank_icon_color", function(self, rank)
  if rank and rank > 0 then
    local index = math.min(math.floor(rank / tweak_data.infamy.icon_rank_step) + 1, #tweak_data.infamy.infamy_icons)
    return (tweak_data.infamy.infamy_icons[index] or tweak_data.infamy.infamy_icons[1]).color
  end
end)

-- Grant infamy skill points
Hooks:PostHook(ExperienceManager, "set_current_rank", "CrimDusk_PostSetInfamy", function(self, rank)
  if rank % managers.skilltree.InfamiesPerPoint == 0 then managers.skilltree:_aquire_points(1) end
end)

Hooks:OverrideFunction(ExperienceManager, "load", function(self, data)
  local state = data.ExperienceManager

  if state then
    self._global.total = state.total
    self._global.xp_gained = state.xp_gained or state.total
    self._global.next_level_data = state.next_level_data
    self._global.level = state.level or Application:digest_value(0, true)
    self._global.rank = state.rank or Application:digest_value(0, true)
    self._global.prestige_xp_gained = state.prestige_xp_gained or Application:digest_value(0, true)

    for level = 0, self:current_level() do managers.upgrades:aquire_from_level_tree(level, true) end
    if not self._global.next_level_data then self:_set_next_level_data(self:current_level() + 1) end
  end

  managers.network.account:experience_loaded()
  self:_check_achievements()
end)