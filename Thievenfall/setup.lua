--[[ **PAYDAY 2: Thievenfall**
**Copyright (C) 2026  ~/cat/em1/nal/**

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>. ]]

if CrimDusk then return end
local FileIdent = "Setup"
CrimDusk = {}

function CrimDusk:Init()
  self.ModPath = ModPath
  self.SavePath = SavePath

  self.SaveFile = self.SavePath .. "thievenfall_save.txt"
  self.SettingsFile = self.SavePath .. "thievenfall_settings.txt"
  self.HoldoutData = self.SavePath .. "thievenfall_holdout.txt"
  self.WeaponLevels = self.SavePath .. "thievenfall_kills.txt"

  self.SettingsData = io.load_as_json(CrimDusk.SettingsFile) or {}
  if type(self.SettingsData.greyscreen) ~= "boolean" then self.SettingsData.greyscreen = true end

  if Global.game_settings and Global.game_settings.difficulty then self.StartingDiff = Global.game_settings.difficulty end

  MenuHelper:LoadFromJsonFile(self.ModPath .. "menus/settings.json", self, self.SettingsData)

  -- Helper functions
  function self.Log(FileIdent, LogMessage, DevMode)
    local DevLog = ""
    if DevMode and Global.CrimDusk and not Global.CrimDusk.Developer then return
    elseif DevMode and Global.CrimDusk and Global.CrimDusk.Developer then DevLog = "_DEV" end
    log("[THIEVENFALL" .. DevLog .. ">" .. FileIdent .. "] " .. LogMessage)
  end -- Yes, this WILL crash without a FileIdent. This is intentional.

  function self.ChatNotify(message)
    if not managers.chat then return end
    managers.chat:_receive_message(ChatManager.GAME, "THIEVENFALL", message, Global.CrimDusk.archicolours.orange)
  end

  function self.EndingText(won)
    local loc = managers.localization
    local CampaignLength, CampaignWon, BainState, VladState, AlmirState, HoxtonState, HectorState, HeistsPlayed, EndingBits

    local perma = CrimDusk.IsPermadeath()
    local CampaignData = Global.CrimDusk.data

    -- Random campaign completed
    if CampaignData.heists_won > #Global.CrimDusk.campaign or perma == "_perma" then
      HeistsPlayed = #CampaignData["heist_chain" .. perma]
      CampaignLength = HeistsPlayed >= 25 and loc:text("crimdusk_chat_campaign_long") or loc:text("crimdusk_chat_campaign_short")

    -- Base campaign completed
    else HeistsPlayed = #Global.CrimDusk.campaign
      CampaignLength = loc:text("crimdusk_chat_campaign_long")
    end

    CampaignWon = won and loc:text("crimdusk_chat_success") or loc:text("crimdusk_chat_failure")
    EndingBits = won and 1 or 0

    -- Are friends alive?
    local VladCaptured, AlmirCaptured
    for _, heist in ipairs(Global.CrimDusk.data["heist_chain" .. perma]) do
      if heist == "chas" and not Global.CrimDusk.data["vlad_freed" .. perma] then VladCaptured = true
      elseif heist == "bex" and not Global.CrimDusk.data["almir_freed" .. perma] then AlmirCaptured = true end
    end

    local VladAlive = not VladCaptured or (VladCaptured and CampaignData["vlad_freed" .. perma])
    local AlmirAlive = not AlmirCaptured or (AlmirCaptured and CampaignData["almir_freed" .. perma])

    BainState = CampaignData["bain_freed" .. perma] and loc:text("crimdusk_chat_bain_alive") or loc:text("crimdusk_chat_bain_dead")
    VladState = VladAlive and loc:text("crimdusk_chat_vlad_alive") or loc:text("crimdusk_chat_vlad_dead")
    AlmirState = AlmirAlive and loc:text("crimdusk_chat_almir_alive") or loc:text("crimdusk_chat_almir_dead")

    EndingBits = EndingBits + (CampaignData["bain_freed" .. perma] and 2 or 0)
    EndingBits = EndingBits + (VladAlive and 4 or 0)
    EndingBits = EndingBits + (AlmirAlive and 8 or 0)

    -- Was Hoxton freed and was Hector killed?
    if CampaignData["free_hoxton" .. perma] >= 4 then
      HoxtonState = loc:text("crimdusk_chat_hoxton_free")
      HectorState = CampaignData["hector_dead" .. perma] and loc:text("crimdusk_chat_hector_dead") or loc:text("crimdusk_chat_hector_alive_free")
      EndingBits = EndingBits + 16 + (CampaignData["hector_dead" .. perma] and 32 or 0)

    else HoxtonState = loc:text("crimdusk_chat_hoxton_prison")
      HectorState = loc:text("crimdusk_chat_hector_alive_prison")
    end

    -- Set up chat message
    DelayedCalls:Add("CrimDusk_CampaignConclusion", 2, function()
      local ending = loc:text("crimdusk_chat_campaign_conclusion", {
        LENGTH = CampaignLength, SUCCESS = CampaignWon,
        BAIN = BainState, VLAD = VladState, ALMIR = AlmirState,
        HOXTON = HoxtonState, HECTOR = HectorState,
        HEISTS = HeistsPlayed
      })
      CrimDusk.ChatNotify(ending)
      NetworkHelper:SendToPeers("CrimDusk_CampaignEnded", EndingBits .. ";" .. HeistsPlayed)
    end)
  end

  function self:WriteSave(FileIdent, SaveReason)
    io.save_as_json(Global.CrimDusk.data, self.SaveFile)
    io.save_as_json(Global.CrimDusk.weapon_levels, self.WeaponLevels)
    self.Log(FileIdent, "Saved " .. self.SaveFile .. " (" .. SaveReason .. ")")
  end -- Yes, this WILL crash without a FileIdent or SaveReason. This is intentional.

  function self.GoLoud()
    NetworkHelper:RemoveReceiveHook("CrimDusk_ForceLoudNetwork")
    Hooks:RemovePostHook("CrimDusk_HostForceLoud")

    local LevelID = Global.game_settings.level_id
    local heist = Global.CrimDusk.heists[LevelID]
    if heist and heist.stealthable then return end

    CrimDusk.Log(FileIdent, "Level ID: " .. LevelID, true)
    DelayedCalls:Add("CrimDusk_GoLoudDelay", (heist and heist.delay) or 3, function()
      if not managers.groupai:state():is_police_called() then managers.groupai:state():on_police_called("empty") end
    end)
  end

  function self.IsPermadeath()
    return CrimDusk.SettingsData.permadeath and "_perma" or ""
  end

  -- Play button text
  function self.PlayButtonLoc()
    local heists_won = "heists_won" .. CrimDusk.IsPermadeath()
    if Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + 1] and CrimDusk.IsPermadeath() ~= "_perma" then
      managers.localization:add_localized_strings({
        ["crimdusk_continue_run_desc"] = managers.localization:text("crimdusk_play_next_desc", {
          HEIST = managers.localization:text("heist_" .. Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + 1])
        }),
        ["menu_crimenet_offline_help"] = managers.localization:text("crimdusk_play_next_desc", {
          HEIST = managers.localization:text("heist_" .. Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + 1])
        }),
        ["menu_choose_new_contract"] = managers.localization:text("crimdusk_campaign_active", {
          HEIST = managers.localization:text("heist_" .. Global.CrimDusk.campaign[Global.CrimDusk.data[heists_won] + 1])
        })
      })
    else managers.localization:add_localized_strings({
        ["crimdusk_continue_run_desc"] = managers.localization:text("crimdusk_play_next_random", {
          NUMHEISTS = #Global.CrimDusk.data["heist_chain" .. CrimDusk.IsPermadeath()]
        }),
        ["menu_crimenet_offline_help"] = managers.localization:text("crimdusk_play_next_random", {
          NUMHEISTS = #Global.CrimDusk.data["heist_chain" .. CrimDusk.IsPermadeath()]
        }),
        ["menu_choose_new_contract"] = managers.localization:text("crimdusk_campaign_inactive")
      })
    end

    local HeistNumText = ""
    local IsEndless = Global.CrimDusk.data[heists_won] >= #Global.CrimDusk.campaign
    if IsEndless then HeistNumText = (Global.CrimDusk.data[heists_won] + 1)
    else HeistNumText = Global.CrimDusk.data[heists_won] + 1 .. "/" .. #Global.CrimDusk.campaign end
    managers.localization:add_localized_strings({
      ["crimdusk_continue_run_title"] = managers.localization:text("crimdusk_play_next_title", { HEIST_NUM = HeistNumText }),
      ["crimdusk_play_offline"] = managers.localization:text("crimdusk_play_offline_title", { HEIST_NUM = HeistNumText })
    })

    if Global.skirmish_manager and Global.skirmish_manager.active_weekly then
      local days = math.floor(math.max(Global.skirmish_manager.active_weekly.end_timestamp - os.time(), 0) / 86400)
      managers.localization:add_localized_strings({
        ["crimdusk_play_holdout_desc"] = managers.localization:text("crimdusk_holdout_desc", { DAYS = days })
      })
    end
  end

  -- Difficulty scaling
  function self.DiffScale()
    if CrimDusk.StartingDiff then return CrimDusk.StartingDiff end

    local permadeath = CrimDusk.IsPermadeath()
    if permadeath == "_perma" or Global.CrimDusk.data.heists_won >= #Global.CrimDusk.campaign then return 8 end
    if (Global.CrimDusk.data.heists_won or 0) < 5 then return Global.CrimDusk.data.heists_won + 2 end

    local HeistsWon = Global.CrimDusk.data["heists_won" .. permadeath] - 5
    local RawDiff = HeistsWon / (#Global.CrimDusk.campaign - 5) * 5 + 2
    return math.floor(RawDiff + 0.5)
  end

  -- Reset campaign state
  function self:SoftReset()
    local permadeath = CrimDusk.IsPermadeath()
    CrimDusk.Log(FileIdent, "Performing soft reset!", true)
    Global.CrimDusk.data["heist_chain" .. permadeath] = {}
    Global.CrimDusk.data["next_heists" .. permadeath] = {}
    Global.CrimDusk.data["heists_skipped" .. permadeath] = {}
    Global.CrimDusk.data["lives" .. permadeath] = 60
    Global.CrimDusk.data["winters_dead" .. permadeath] = false
    Global.CrimDusk.data["hector_dead" .. permadeath] = false
    Global.CrimDusk.data["bain_freed" .. permadeath] = false
    Global.CrimDusk.data["vlad_freed" .. permadeath] = false
    Global.CrimDusk.data["almir_freed" .. permadeath] = false
    Global.CrimDusk.data["rust_recruited" .. permadeath] = false
    Global.CrimDusk.data["dentist_heists" .. permadeath] = 0
    for campaign, _ in pairs(Global.CrimDusk.mini_campaigns) do Global.CrimDusk.data[campaign .. permadeath] = 1 end
  end

  function self:Reset()
    CrimDusk.Log(FileIdent, "Performing full reset!", true)
    Global.CrimDusk.data = {
      heists_won = 0, heist_chain = {}, next_heists = {}, heists_skipped = {}, lives = 60,
      heists_won_perma = 0, heist_chain_perma = {}, next_heists_perma = {}, heists_skipped_perma = {}, lives_perma = 60,

      winters_dead = false, hector_dead = false,
      winters_dead_perma = false, hector_dead_perma = false,

      bain_freed = false, vlad_freed = false, almir_freed = false,
      bain_freed_perma = false, vlad_freed_perma = false, almir_freed_perma = false,

      rust_recruited = false,
      rust_recruited_perma = false,

      dentist_heists = 0,
      dentist_heists_perma = 0
    }
    for campaign, _ in pairs(Global.CrimDusk.mini_campaigns) do
      Global.CrimDusk.data[campaign] = 1
      Global.CrimDusk.data[campaign .. "_perma"] = 1
    end
  end

  self.Log(FileIdent, "Initialisation completed!", true)
end

Global.load_crime_net = false
if Global.game_settings and Global.game_settings.difficulty then
  Global.game_settings.difficulty = Global.job_manager.current_job and Global.game_settings.difficulty or nil
end

CrimDusk:Init()

if NetworkHelper:IsHost() and not CrimDusk.SettingsData.permadeath and (Global.CrimDusk and (Global.CrimDusk.data.heists_won or 0) < 5) then
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
end

-- THIS SECTION ONLY RUNS ONCE ON GAME LAUNCH --
if Global.CrimDusk then return end

Global.CrimDusk = {}
function Global.CrimDusk:Init()
  self.ModVersion = BeardLib.Utils:FindMod("Thievenfall").AssetUpdates.version
  CrimDusk.Log(FileIdent, "Playing Thievenfall v" .. self.ModVersion)
  self.Developer = BeardLib.Utils:FindMod("Thievenfall"):GetSetting("DevelopMode")
  CrimDusk.Log(FileIdent, "DevMode active!", true)

  -- tweakdata modification tables
  dofile(CrimDusk.ModPath .. "lua/tables/campaign.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/heists.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/gameplay.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/heists.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/assets.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/holdout.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/weapons.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/weaponparts.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/melee.lua")
  dofile(CrimDusk.ModPath .. "lua/tables/colours.lua")

  -- Load save
  CrimDusk.Log(FileIdent, "Attempting to load save file...")
  self.data = io.load_as_json(CrimDusk.SaveFile)
  if self.data then
    CrimDusk.Log(FileIdent, "Load successful!")

    -- Data validation
    self.data.heists_won = self.data.heists_won or 0
    self.data.heists_won_perma = self.data.heists_won_perma or 0
    self.data.heist_chain = self.data.heist_chain or {}
    self.data.heist_chain_perma = self.data.heist_chain_perma or {}
    self.data.next_heists = self.data.next_heists or {}
    self.data.next_heists_perma = self.data.next_heists_perma or {}
    self.data.heists_skipped = self.data.heists_skipped or {}
    self.data.heists_skipped_perma = self.data.heists_skipped_perma or {}
    self.data.lives = self.data.lives or 60
    self.data.lives_perma = self.data.lives_perma or 60

    -- Flags for post-game campaign
    self.data.bain_freed = self.data.bain_freed or false
    self.data.bain_freed_perma = self.data.bain_freed_perma or false
    self.data.vlad_freed = self.data.vlad_freed or false
    self.data.vlad_freed_perma = self.data.vlad_freed_perma or false
    self.data.almir_freed = self.data.almir_freed or false
    self.data.almir_freed_perma = self.data.almir_freed_perma or false
    self.data.dentist_heists = self.data.dentist_heists or 0
    self.data.dentist_heists_perma = self.data.dentist_heists_perma or 0

    for campaign, _ in pairs(self.mini_campaigns) do
      self.data[campaign] = self.data[campaign] or 1
      self.data[campaign .. "_perma"] = self.data[campaign .. "_perma"] or 1
    end

    self.data.rust_recruited = self.data.rust_recruited or false
    self.data.rust_recruited_perma = self.data.rust_recruited_perma or false

  else
    CrimDusk:Reset()
    self.data.weekly_holdout = {}
    CrimDusk:WriteSave(FileIdent, "save created")
  end

  self.holdout_data = io.load_as_json(CrimDusk.HoldoutData) or {}
  self.weapon_levels = io.load_as_json(CrimDusk.WeaponLevels) or {}

  CrimDusk.Log(FileIdent, "Global initialisation completed!", true)
end

Global.CrimDusk:Init()