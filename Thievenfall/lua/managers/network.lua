local FileIdent = "NetworkManager"
NetworkMatchMakingSTEAM._BUILD_SEARCH_INTEREST_KEY = "thievenfall_v" .. Global.CrimDusk.ModVersion

-- Client hooks
if NetworkHelper:IsClient() then
  --[[
  NetworkHelper:AddReceiveHook("CrimDusk_Prologue", "CrimDusk_SetPrologueDiffs", function()
    Hooks:Add("LocalizationManagerPostInit", "CrimDusk_PDTHNames", function(loc)
      loc:add_localized_strings({
        ["menu_difficulty_normal"] = loc:text("crimdusk_pdth_normal"),
        ["menu_asset_risklevel_0"] = loc:text("crimdusk_pdth_normal"),
        ["menu_difficulty_hard"] = loc:text("crimdusk_pdth_hard"),
        ["menu_asset_risklevel_1"] = loc:text("crimdusk_pdth_hard"),
        ["menu_difficulty_very_hard"] = loc:text("crimdusk_pdth_very_hard"),
        ["menu_asset_risklevel_2"] = loc:text("crimdusk_pdth_very_hard"),
        ["menu_difficulty_easy_wish"] = loc:text("crimdusk_pdth_mayhem"),
        ["menu_asset_risklevel_4"] = loc:text("crimdusk_pdth_mayhem"),
        ["menu_difficulty_apocalypse"] = loc:text("crimdusk_pdth_death_wish"),
        ["menu_asset_risklevel_5"] = loc:text("crimdusk_pdth_death_wish")
      })
    end)
  end)
  ]]

  -- Sync campaign progress (up to post-game)
  NetworkHelper:AddReceiveHook("CrimDusk_SyncCampaignProgress", "CrimDusk_ReceiveHeistCount", function(data)
    -- Only want to sync if we are around the same point in the campaign ourselves
    -- This means groups can play together and everyone makes the same progress, regardless of host
    local HeistsWon = tonumber(data)
    if HeistsWon == Global.CrimDusk.data.heists_won + 1 or Global.CrimDusk.data.heists_won - 1 then
      Global.CrimDusk.data.heists_won = HeistsWon

      -- Sync campaign events
      if HeistsWon == Global.CrimDusk.HeistIndex.Breakout then Global.CrimDusk.data.free_hoxton = 4 end
      if HeistsWon == Global.CrimDusk.HeistIndex.Hector then Global.CrimDusk.data.hector_dead = true end
      if HeistsWon == Global.CrimDusk.HeistIndex.Rust then Global.CrimDusk.data.rust_recruited = true end
      if HeistsWon == Global.CrimDusk.HeistIndex.Bain then Global.CrimDusk.data.bain_freed = true end
      if HeistsWon == Global.CrimDusk.HeistIndex.Vlad then Global.CrimDusk.data.vlad_freed = true end
      if HeistsWon == Global.CrimDusk.HeistIndex.Almir then Global.CrimDusk.data.almir_freed = true end

      CrimDusk:WriteSave(FileIdent, "synced campaign progress")
    end
  end)

  -- Change difficulty
  NetworkHelper:AddReceiveHook("CrimDusk_ChangeDifficulty", "CrimDusk_ReceiveDifficultyIncrease", function(data)
    Global.game_settings.difficulty = data
    tweak_data:set_difficulty()
  end)

  -- Set host's White House payout
  NetworkHelper:AddReceiveHook("CrimDusk_WhiteHousePayout", "CrimDusk_ReceiveCampaignPayout", function(data)
    tweak_data.narrative.jobs.vit.payout[1] = tonumber(data)
  end)

  -- Sync campaign victory
  NetworkHelper:AddReceiveHook("CrimDusk_CampaignEnded", "CrimDusk_SyncCampaignEnding", function(data)
    Global.CrimDusk.data.lives = 60
    local EndingValue, HeistsPlayed = data:match("([^;]+);(.*)")

    local EndingBits = {}
    for i = 1, 6 do EndingBits[i] = bit.band(bit.rshift(tonumber(EndingValue), i - 1), 1) == 1 end
    -- convert ending number into bits so we can reconstruct the campaign summary locally

    local CampaignLength = HeistsPlayed >= 12 and loc:text("crimdusk_chat_campaign_long") or loc:text("crimdusk_chat_campaign_short")
    local CampaignWon = EndingBits[1] and loc:text("crimdusk_chat_success") or loc:text("crimdusk_chat_failure")
    local BainState = EndingBits[2] and loc:text("crimdusk_chat_bain_alive") or loc:text("crimdusk_chat_bain_dead")
    local VladState = EndingBits[3] and loc:text("crimdusk_chat_vlad_alive") or loc:text("crimdusk_chat_vlad_dead")
    local AlmirState = EndingBits[4] and loc:text("crimdusk_chat_almir_alive") or loc:text("crimdusk_chat_almir_dead")

    local HoxtonState, HectorState
    if EndingBits[5] then
      HoxtonState = loc:text("crimdusk_chat_hoxton_free")
      HectorState = EndingBits[6] and loc:text("crimdusk_chat_hector_dead") or loc:text("crimdusk_chat_hector_alive_free")

    else HoxtonState = loc:text("crimdusk_chat_hoxton_prison")
      HectorState = loc:text("crimdusk_chat_hector_alive_prison")
    end

    local ending = loc:text("crimdusk_chat_campaign_conclusion", {
      LENGTH = CampaignLength, SUCCESS = CampaignWon,
      BAIN = BainState, VLAD = VladState, ALMIR = AlmirState,
      HOXTON = HoxtonState, HECTOR = HectorState,
      HEISTS = HeistsPlayed
    })

    CrimDusk.ChatNotify(ending)
  end)
return end

-- Host hooks

-- Force maskup
NetworkHelper:AddReceiveHook("CrimDusk_MaskedUp", "CrimDusk_ForceLoudNetwork", function()
  CrimDusk.GoLoud()
end)