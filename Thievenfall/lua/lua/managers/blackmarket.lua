-- Replace suit with LBV
Hooks:PreHook(BlackMarketManager, "_setup_armors", "CrimDusk_BMSetupArmorsPre", function(self)
  self._defaults.armor = "level_2"
end)

-- Replace weapon butt with fists
Hooks:PreHook(BlackMarketManager, "_setup_melee_weapons", "CrimDusk_BMSetupArmorsPre", function(self)
  self._defaults.melee_weapon = "fists"
end)

-- Apply previous changes past first boot
Hooks:PostHook(BlackMarketManager, "_setup", "CrimDusk_BMSetupPost", function(self)
  self._defaults.armor = "level_2"
  self._defaults.melee_weapon = "fists"
end)

-- No default crew unlocks
Hooks:OverrideFunction(BlackMarketManager, "_setup_unlocked_crew_items", function(self)
  self._global._unlocked_crew_items = self._global._unlocked_crew_items or {}
end)

-- Don't include suit when sorting armours
Hooks:OverrideFunction(BlackMarketManager, "get_sorted_armors", function(self, hide_locked)
  local sort_data = {}
  for id, d in pairs(Global.blackmarket_manager.armors) do
    if (not hide_locked or d.unlocked) and id ~= "level_1" then table.insert(sort_data, id) end
  end

  local armor_level_data = {}
  for level, data in pairs(tweak_data.upgrades.level_tree) do
    if data.upgrades then
      for _, upgrade in ipairs(data.upgrades) do
        local def = tweak_data.upgrades.definitions[upgrade]
        if def.armor_id then armor_level_data[def.armor_id] = level end
      end
    end
  end

  table.sort(sort_data, function(x, y)
    local x_level = x == "level_2" and 0 or armor_level_data[x] or 100
    local y_level = y == "level_2" and 0 or armor_level_data[y] or 100
    return x_level < y_level
  end)

  return sort_data, armor_level_data
end)

-- Assign random van skin
Hooks:OverrideFunction(BlackMarketManager, "equipped_van_skin", function()
  local skins = { "default", "brown", "green", "grey", "red", "white", "yellow", "icecream", "spooky" }
  if managers.dlc:is_dlc_unlocked("overkill_pack") then table.insert(skins, "overkill") end
  return skins[math.random(1, #skins)]
end)