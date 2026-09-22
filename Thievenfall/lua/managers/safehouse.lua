local FileIdent = "SafehouseManager"

-- Disable achievement milestone coins
Hooks:OverrideFunction(CustomSafehouseManager, "add_coins_ingore_locked", function() end)

local function SetMoneyMultiplier(rooms)
  Global.CrimDusk.money_multiplier = 1 + (2.5 * rooms * 0.01)
  CrimDusk.Log(FileIdent, "Safehouse money mult: " .. Global.CrimDusk.money_multiplier, true)
end

Hooks:PostHook(CustomSafehouseManager, "load", "CrimDusk_LoadSafeHouseManager", function(self)
  SetMoneyMultiplier(self:total_room_unlocks_purchased())
end)

Hooks:PostHook(CustomSafehouseManager, "purchase_room_tier", "CrimDusk_SafeHouseUpgradeRoom", function(self)
  SetMoneyMultiplier(self:total_room_unlocks_purchased())
end)