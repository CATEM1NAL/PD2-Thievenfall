local FileIdent = "MenuManager"

function MenuCallbackHandler:CrimDusk_CreateLobby()
  Global.game_settings.difficulty = "normal"
  -- wasn't needed but game now sometimes crashes after opening lobby settings because ????
  self:create_lobby()
end

function MenuCallbackHandler:CrimDusk_Safehouse() managers.menu:open_node("custom_safehouse") end

-- Mod options
function MenuCallbackHandler:CrimDusk_SaveToggleSettings(item)
  if Utils:IsInGameState() then CrimDusk.Log(FileIdent, "Can't change settings in-game!") return end
  CrimDusk.SettingsData[item:name():sub(10)] = item:value() == "on"

  CrimDusk.PlayButtonLoc()
  io.save_as_json(CrimDusk.SettingsData, CrimDusk.SettingsFile)
end

function MenuCallbackHandler:CrimDusk_SaveToggleSettingsInGame(item)
  CrimDusk.SettingsData[item:name():sub(10)] = item:value() == "on"
  if item:name() == "crimdusk_greyscreen" then managers.environment_controller:set_last_life() end
  io.save_as_json(CrimDusk.SettingsData, CrimDusk.SettingsFile)
end

-- Currently unused
function MenuCallbackHandler:CrimDusk_SaveChoiceSettings(item)
  if Utils:IsInGameState() then CrimDusk.Log(FileIdent, "Can't change settings in-game!") return end
  CrimDusk.SettingsData[item:name():sub(10)] = item:value()
  io.save_as_json(CrimDusk.SettingsData, CrimDusk.SettingsFile)
end

function MenuCallbackHandler:CrimDusk_ResetCampaign()
  if Utils:IsInGameState() then CrimDusk.Log(FileIdent, "Can't change settings in-game!") return end
  CrimDusk.Reset()

  CrimDusk.PlayButtonLoc()
  CrimDusk:WriteSave(FileIdent, "campaign reset")
end

-- Add custom buttons to menu
local function InjectCrimDuskButtons(node)
  local data = {
    type = "CoreMenuItem.Item",
  }

  local params = {
    name = "crimdusk_createlobby_btn",
    text_id = "crimdusk_create_lobby_title",
    help_id = "crimdusk_create_lobby_desc",
    callback = "CrimDusk_CreateLobby",
    font_size = 35,
    font = tweak_data.menu.pd2_large_font
  }

  local new_item = node:create_item(data, params)

  new_item.dirty_callback = callback(node, node, "item_dirty")
  if node.callback_handler then new_item:set_callback_handler(node.callback_handler) end

  local position = 1
  table.insert(node._items, position, new_item)

  -- Add the safehouse button
  data = { type = "CoreMenuItem.Item" }
  params = {
    name = "crimdusk_safehouse",
    text_id = "menu_cn_chill",
    help_id = "crimdusk_safehouse_desc",
    callback = "CrimDusk_Safehouse",
    visible_callback = "is_not_server",
    font = tweak_data.menu.pd2_medium_font
  }

  new_item = node:create_item(data, params)

  new_item.dirty_callback = callback(node, node, "item_dirty")
  if node.callback_handler then new_item:set_callback_handler(node.callback_handler) end

  position = 1
  table.insert(node._items, position, new_item)
end

-- MENU CHANGES START HERE --
Hooks:Add("MenuManagerBuildCustomMenus", "CrimDusk_MenuTweaks", function(menu_manager, nodes)
  local mainmenu = nodes.main
  local pausemenu = nodes.pause
  local lobbymenu = nodes.lobby

  -- Main Menu
  if mainmenu ~= nil then

    CrimDusk.PlayButtonLoc()
    InjectCrimDuskButtons(mainmenu)

    -- Hides all the unnecessary menu buttons
    local HiddenButtons = { crimenet = true, story_missions = true, crimdusk_safehouse = true }

    for i, item in pairs(mainmenu._items) do
      if HiddenButtons[item._parameters.name] then item:set_visible(false) end
    end

    if RestructuredMenus then
      if RestructuredMenus.settings.main_add_crimenet_broker then
        MenuHelper:HideMenuItem(mainmenu, 'contract_broker')
      end
    end
  end

  -- Lobby
  if lobbymenu ~= nil then
    InjectCrimDuskButtons(lobbymenu)

    -- Hides all the unnecessary menu buttons
    local HiddenButtons = { story_missions = true, crimdusk_createlobby_btn = true }

    for i, item in pairs(lobbymenu._items) do
      if HiddenButtons[item._parameters.name] then item:set_visible(false) end
    end

    if RestructuredMenus then
      if RestructuredMenus.settings.lobby_add_contract_broker then
        MenuHelper:HideMenuItem(lobbymenu, "contract_broker")
      end
    end
  end

  -- Pause Menu
  if pausemenu ~= nil then
    local breakCounter = 0
    for i, item in pairs(pausemenu._items) do

      if item._parameters.name == "abort_mission" then
        item:set_visible(false)

      elseif item._parameters.name == "end_game" then
        item:set_visible(false)
      end
    end
  end
end)
-- MENU CHANGES END HERE --

Hooks:PostHook(MenuManager, "do_clear_progress", "CrimDawn_ResetSave", function(self)
  Global.CrimDusk.data.weekly_holdout = {}
  Global.CrimDusk.weapon_levels = {}
  CrimDusk:Reset()

  io.save_as_json(Global.CrimDusk.holdout_data, CrimDusk.HoldoutData)
  CrimDusk:WriteSave(FileIdent, "wiped save data")
end)