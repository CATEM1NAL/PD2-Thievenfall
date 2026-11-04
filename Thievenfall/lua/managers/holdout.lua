local FileIdent = "HoldoutManager"

Hooks:OverrideFunction(SkirmishManager, "activate_weekly_skirmish")

-- Add weekly number to save data
Hooks:OverrideFunction(SkirmishManager, "save", function(self, data)
  data.skirmish = {
    last_weekly = self._global.last_weekly,
    claimed_rewards = self._global.claimed_rewards,
    special_rewards = self._global.special_rewards
  }
end)

-- Load last weekly played
Hooks:PostHook(SkirmishManager, "load", "CrimDusk_LoadLastHoldoutNum", function(self, data)
  self._global.last_weekly = data.skirmish.last_weekly

  if (self._global.last_weekly or 0) < math.floor((os.time() + 259200) / 604800) then
    managers.localization:add_localized_strings({ ["menu_weekly_skirmish"] = managers.localization:text("crimdusk_new_holdout") })
  end
end)

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
  local NotCompleted = (self._global.last_weekly or 0) < math.floor((os.time() + 259200) / 604800)
  if NotCompleted then
    Global.skirmish_manager.last_weekly = math.floor((os.time() - TimerManager:game():time() + 259200) / 604800) -- Current week number
    CrimDusk.Log(FileIdent, "holdout completed")

  else return { coins = 0, special_rewards = {}, additional_lootdrops = 1 } end
end)

--[[ Could be nice to expand this to also save the highest wave you reached, and if you
play with someone else and beat your previous highest wave it gives you the missing rewards
(previous record 5, play again and reach 7, gain two waves worth of rewards) ]]