Hooks:PostHook(DLCTweakData, "init", "CrimDusk_InitDLCTweakData", function(self)
  self.wild_char = deep_clone(self.wild)
  self.wild_char.dlc = "has_wild_char"
  self.wild_char.content.loot_global_value = "wild_char"
  self.wild_char.content.loot_drops = nil

  self.freed_old_hoxton.content.loot_global_value = "freed_old_hoxton"
  self.freed_old_hoxton.achievement_id = nil

  for dlc, _ in pairs(self) do
    if self[dlc].content and self[dlc].content.loot_drops then
      for i = #self[dlc].content.loot_drops, 1, -1 do
        if self[dlc].content.loot_drops[i].type_items == "weapon_mods" and self[dlc].content.loot_drops[i].item_entry ~= "wpn_fps_upg_ns_ass_filter" then
          table.remove(self[dlc].content.loot_drops, i)
        end
      end
    end
  end
end)