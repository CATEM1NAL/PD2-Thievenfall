Hooks:OverrideFunction(GenericDLCManager, "is_content_skirmish_locked", function() return false end)
Hooks:OverrideFunction(GenericDLCManager, "is_content_crimespree_locked", function() return false end)

Hooks:PostHook(GenericDLCManager, "has_dlc", "CrimDusk_GiveCommunityItems", function(self, dlc)
  if dlc == "pd2_clan" then return true end -- Force unlock community items
end)

-- Unlocked characters
Hooks:OverrideFunction(GenericDLCManager, "has_freed_old_hoxton", function()
  local permadeath = CrimDusk.IsPermadeath()
  if permadeath == "" then return Global.CrimDusk.data.heists_won < Global.CrimDusk.PDTHLength or Global.CrimDusk.data.free_hoxton > 3
  else return Global.CrimDusk.data.free_hoxton_perma > 3 end
end)

function GenericDLCManager:has_wild_char() return Global.CrimDusk.data["rust_recruited" .. CrimDusk.IsPermadeath()] end