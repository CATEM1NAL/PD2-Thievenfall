if Global.game_settings and Global.game_settings.level_id == "chill_combat" then return end
local FileIdent = "Victory"

local lives = NetworkHelper:IsClient() and "lives" or "lives" .. CrimDusk.IsPermadeath()

Hooks:PostHook(VictoryState, "at_enter", "CrimDusk_HeistWon", function(self)
  if managers.skirmish:is_skirmish() then -- Weekly Holdout
    Global.CrimDusk.holdout_data = Global.skirmish_manager.active_weekly
    io.save_as_json(Global.CrimDusk.holdout_data, CrimDusk.HoldoutData)
    CrimDusk.Log(FileIdent, "holdout completed")
  return end

  if Global.CrimDusk.data[lives] == -1 then Global.CrimDusk.data[lives] = -2 end
  if NetworkHelper:IsClient() then CrimDusk:WriteSave(FileIdent, "heist completed (client)") return end

  local heists_won = "heists_won" .. CrimDusk.IsPermadeath()
  if managers.job:on_last_stage() then
    do local i = 1

      if Global.CrimDusk.data.heists_won < #Global.CrimDusk.campaign and CrimDusk.IsPermadeath() ~= "_perma" then
        local NextHeist = Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + i]
        while Global.CrimDusk.heist_dlc[NextHeist] and not managers.dlc:is_dlc_unlocked(Global.CrimDusk.heist_dlc[NextHeist]) do
          i = i + 1
          NextHeist = Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + i]
        end
      end

      if not Global.game_settings.single_player and Global.CrimDusk.data[heists_won] + i == Global.CrimDusk.PDTHLength then i = i + 3 end
      Global.CrimDusk.data[heists_won] = Global.CrimDusk.data[heists_won] + i
    end

    CrimDusk.Log(FileIdent, "Heists won: " .. Global.CrimDusk.data[heists_won])

    local Permadeath = CrimDusk.IsPermadeath()
    local CurrentHeist = managers.job:current_job_id()

    if CurrentHeist == "bph" then Global.CrimDusk.data["bain_freed" .. Permadeath] = true
    elseif CurrentHeist == "sand" then Global.CrimDusk.data["vlad_freed" .. Permadeath] = true
    elseif CurrentHeist == "pex" then Global.CrimDusk.data["almir_freed" .. Permadeath] = true
    elseif CurrentHeist == "cd_biker1" then Global.CrimDusk.data["rust_recruited" .. Permadeath] = true
    elseif Global.CrimDusk.mini_campaign_data.dentist[CurrentHeist] then Global.CrimDusk.data["dentist_heists" .. Permadeath] = Global.CrimDusk.data["dentist_heists" .. Permadeath] + 1
    elseif CurrentHeist == "vit" then
      CrimDusk.EndingText(true)
      CrimDusk.SoftReset()
      return CrimDusk:WriteSave(FileIdent, "campaign completed")
    end

    NetworkHelper:SendToPeers("CrimDusk_SyncCampaignProgress", math.min(Global.CrimDusk.data.heists_won, #Global.CrimDusk.campaign))
    if Global.CrimDusk.data[heists_won] == #Global.CrimDusk.campaign and Permadeath == "" then
      CrimDusk:WriteSave(FileIdent, "heist completed (main campaign)")
    return end

    -- Post-game campaign
    Global.CrimDusk.data["heist_chain" .. Permadeath] = Global.CrimDusk.data["heist_chain" .. Permadeath] or {}
    Global.CrimDusk.data["heists_skipped" .. Permadeath] = Global.CrimDusk.data["heists_skipped" .. Permadeath] or {}

    local ActiveContracts = Global.CrimDusk.data["next_heists" .. Permadeath]
    for i = 1, #ActiveContracts do

      -- Move played heists to heist chain
      if ActiveContracts[i] == Global.CrimDusk.job_to_wrapper[CurrentHeist] or CurrentHeist then
        table.insert(Global.CrimDusk.data["heist_chain" .. Permadeath], (Global.CrimDusk.job_to_wrapper[ActiveContracts[i]] or ActiveContracts[i]))

      -- Move unplayed heists to heists skipped
      else table.insert(Global.CrimDusk.data["heists_skipped" .. Permadeath], (Global.CrimDusk.job_to_wrapper[ActiveContracts[i]] or ActiveContracts[i])) end

    end

    Global.CrimDusk.data["next_heists" .. CrimDusk.IsPermadeath()] = {}

    -- Increase mini-campaign progress if current heist is part of one
    for Campaign, _ in pairs(Global.CrimDusk.mini_campaign_data) do
      if type(Global.CrimDusk.mini_campaign_data[Campaign][CurrentHeist]) == "number" then
        Global.CrimDusk.data[Campaign .. Permadeath] = Global.CrimDusk.data[Campaign .. Permadeath] + 1
      break end
    end

    CrimDusk:WriteSave(FileIdent, "heist completed (post-game)")
  end
end)