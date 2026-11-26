Hooks:PreHook(LootDropTweakData, "_create_global_value_list_map", "CrimDusk_CreateNewGlobalValues", function(self)
  self.global_values.wild_char = deep_clone(self.global_values.wild)
  self.global_values.wild_char.unlock_id = "bm_global_value_wild_char_unlock"
  self.global_values.wild_char.unique_lock_icon = "guis/textures/pd2/lock_achievement"
  self.global_values.wild_char.unique_lock_color = nil

  self.global_values.freed_old_hoxton = deep_clone(self.global_values.pd2_clan)
  self.global_values.freed_old_hoxton.unlock_id = "bm_global_value_hoxton_unlock"
  self.global_values.freed_old_hoxton.unique_lock_icon = "guis/textures/pd2/lock_achievement"
  self.global_values.freed_old_hoxton.unique_lock_color = nil

  self.global_values.crimdusk_hidden_item = { dlc = true, hide_unavailable = true }

  table.insert(self.global_value_list_index, "wild_char")
  table.insert(self.global_value_list_index, "freed_old_hoxton")
  table.insert(self.global_value_list_index, "crimdusk_hidden_item")
end)