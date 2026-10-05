local FileIdent = "HoldoutManager"

-- Set tooltip for menu button
if not Global.skirmish_manager or not Global.skirmish_manager.active_weekly then
  Hooks:PostHook(SkirmishManager, "activate_weekly_skirmish", "CrimDusk_InitHoldoutManager", function()
    local days = math.floor(math.max(Global.skirmish_manager.active_weekly.end_timestamp - os.time(), 0) / 86400)
    managers.localization:add_localized_strings({
      ["crimdusk_play_holdout_desc"] = managers.localization:text("crimdusk_holdout_desc", { DAYS = days })
    })
  end)
end

-- Used by host
Hooks:OverrideFunction(SkirmishManager, "on_start_assault", function(self)
  local wave_number = managers.groupai:state():get_assault_number()

  Global.game_settings.difficulty = Global.CrimDusk.holdout_difficulty[wave_number]
  tweak_data:set_difficulty()
  CrimDusk.Log(FileIdent, "Difficulty changed to: " .. Global.CrimDusk.holdout_difficulty[wave_number], true)

  self:update_matchmake_attributes()
end)

-- Used by clients
Hooks:OverrideFunction(SkirmishManager, "sync_start_assault", function(self, wave)
  if not self:is_skirmish() or not Global.CrimDusk.holdout_difficulty[wave] then return end

  Global.game_settings.difficulty = Global.CrimDusk.holdout_difficulty[wave]
  tweak_data:set_difficulty()
  CrimDusk.Log(FileIdent, "Difficulty changed to: " .. Global.CrimDusk.holdout_difficulty[wave], true)

  self._synced_wave_number = wave
end)

-- Stop Holdout rewards from being given multiple times
Hooks:PostHook(SkirmishManager, "get_mass_drop_data", "CrimDusk_DisableHoldoutDrops", function(self)
  local LastWeekly = Global.CrimDusk.holdout_data

  local AlreadyCompleted = true
  for key, value in pairs(Global.skirmish_manager.active_weekly) do
    if LastWeekly[key] ~= value then AlreadyCompleted = false break end
  end

  if AlreadyCompleted then return { coins = 0, special_rewards = {}, additional_lootdrops = 1 }
  else Global.CrimDusk.holdout_data = Global.skirmish_manager.active_weekly
    io.save_as_json(Global.CrimDusk.holdout_data, CrimDusk.HoldoutData)
    CrimDusk.Log(FileIdent, "holdout completed")
  end
end)

--[[ Could be nice to expand this to also save the highest wave you reached, and if you
play with someone else and beat your previous highest wave it gives you the missing rewards
(previous record 5, play again and reach 7, gain two waves worth of rewards) ]]