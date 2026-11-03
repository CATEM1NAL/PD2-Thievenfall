if Global.game_settings and Global.game_settings.level_id == "chill_combat" then return end
local FileIdent = "Gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDusk_HeistFailed", function(self)
  -- Weekly Holdout
  if managers.skirmish:is_skirmish() then
    Global.skirmish_manager.last_weekly = math.floor((os.time() - TimerManager:game():time() + 259200) / 604800) -- Current week number
    CrimDusk.Log(FileIdent, "holdout failed")
  return end

  -- Pro mode resets the whole campaign
  if NetworkHelper:IsHost() and CrimDusk.SettingsData.permadeath then
    CrimDusk:SoftReset()
    Global.CrimDusk.data.heists_won_perma = 0
    CrimDusk.EndingText(false)
  return end

  -- We don't want to go backwards on these heists
  local checkpoints = {
    [Global.CrimDusk.PDTHLength] = true,
    [Global.CrimDusk.PDTHLength + 1] = true,
    [Global.CrimDusk.PDTHLength + 2] = true,
    [Global.CrimDusk.PDTHLength + 3] = true
  }

  Global.CrimDusk.data.lives = 60 -- Clamped later in playerdamage unit

  local CurrentHeist = managers.job:current_job_id()
  CurrentHeist = Global.CrimDusk.job_to_wrapper[CurrentHeist] or CurrentHeist

  if NetworkHelper:IsClient() then CrimDusk:WriteSave(FileIdent, "heist failed") return

  -- Failing during the PDTH section skips ahead
  elseif Global.CrimDusk.data.heists_won < Global.CrimDusk.PDTHLength then
    local NextHeist = Global.game_settings.single_player and Global.CrimDusk.PDTHLength or Global.CrimDusk.PDTHLength + 3
    Global.CrimDusk.data.heists_won = NextHeist

  -- Campaign failed :(
  elseif Global.CrimDusk.data.heists_won >= #Global.CrimDusk.campaign then
    if CurrentHeist == "vit" then 
      CrimDusk.SoftReset()
      CrimDusk.EndingText(false)
    return end

    Global.CrimDusk.data.heist_chain = Global.CrimDusk.data.heist_chain or {}
    Global.CrimDusk.data.heists_skipped = Global.CrimDusk.data.heists_skipped or {}

    local ActiveContracts = Global.CrimDusk.data.next_heists
    for i = 1, #ActiveContracts do
      if ActiveContracts[i] == CurrentHeist then table.insert(Global.CrimDusk.data.heist_chain, CurrentHeist)
      else table.insert(Global.CrimDusk.data.heists_skipped, CurrentHeist) end
    end
    Global.CrimDusk.data.next_heists = {}

  -- Go back, do not pass go (main campaign only)
  elseif not checkpoints[Global.CrimDusk.data.heists_won] then
    Global.CrimDusk.data.heists_won = Global.CrimDusk.data.heists_won - 1
    NetworkHelper:SendToPeers("CrimDusk_SyncCampaignProgress", math.min(Global.CrimDusk.data.heists_won, #Global.CrimDusk.campaign))
  end

  CrimDusk:WriteSave(FileIdent, "heist failed")
end)