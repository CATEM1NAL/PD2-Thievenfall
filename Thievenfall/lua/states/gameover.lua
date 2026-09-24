if Global.game_settings and Global.game_settings.level_id == "chill_combat" then return end
local FileIdent = "Gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDusk_HeistFailed", function(self)
  if managers.skirmish:is_skirmish() then -- Weekly Holdout
    Global.CrimDusk.holdout_data = Global.skirmish_manager.active_weekly
    io.save_as_json(Global.CrimDusk.holdout_data, CrimDusk.HoldoutData)
    CrimDusk.Log(FileIdent, "holdout failed")
  return end

  if NetworkHelper:IsHost() and CrimDusk.SettingsData.permadeath then
    CrimDusk:SoftReset()
    Global.CrimDusk.data.heists_won_perma = 0
    CrimDusk.EndingText(false)
  return end

  local checkpoints = { [5] = true, [6] = true, [7] = true, [8] = true }
  Global.CrimDusk.data.lives = 60

  local CurrentHeist = managers.job:current_job_id()

  if NetworkHelper:IsClient() then CrimDusk:WriteSave(FileIdent, "heist failed") return

  elseif Global.CrimDusk.data.heists_won < 5 then
    local NextHeist = Global.game_settings.single_player and 5 or 8
    Global.CrimDusk.data.heists_won = NextHeist

  elseif Global.CrimDusk.data.heists_won >= #Global.CrimDusk.campaign then
    if managers.job:current_job_id() == "vit" then 
      CrimDusk.SoftReset()
      CrimDusk.EndingText(false)
    return end

    Global.CrimDusk.data.heist_chain = Global.CrimDusk.data.heist_chain or {}
    Global.CrimDusk.data.heists_skipped = Global.CrimDusk.data.heists_skipped or {}

    local ActiveContracts = Global.CrimDusk.data.next_heists
    for i = 1, #ActiveContracts do
      if ActiveContracts[i] == Global.CrimDusk.job_to_wrapper[CurrentHeist] or CurrentHeist then
        table.insert(Global.CrimDusk.data.heist_chain, (Global.CrimDusk.job_to_wrapper[ActiveContracts[i]] or ActiveContracts[i]))

      else table.insert(Global.CrimDusk.data.heists_skipped, (Global.CrimDusk.job_to_wrapper[ActiveContracts[i]] or ActiveContracts[i])) end
    end
    Global.CrimDusk.data.next_heists = {}

  elseif not checkpoints[Global.CrimDusk.data.heists_won] then
    Global.CrimDusk.data.heists_won = Global.CrimDusk.data.heists_won - 1
    NetworkHelper:SendToPeers("CrimDusk_SyncCampaignProgress", math.min(Global.CrimDusk.data.heists_won, #Global.CrimDusk.campaign))
  end

  CrimDusk:WriteSave(FileIdent, "heist failed")
end)