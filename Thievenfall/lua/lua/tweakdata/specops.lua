-- Remove impossible to complete objectives
Hooks:PostHook(TangoTweakData, "init", "CrimDusk_SpecOpsJobTweak", function(self, tweak_data)
  self.challenges[1].objectives = { tweak_data.safehouse:_progress("tango_1_key_1", 1, { name_id = "menu_tango_key", desc_id = "menu_tango_1_key_1_desc" }) }
  self.challenges[2].objectives = { tweak_data.safehouse:_progress("tango_2_case", 1, { name_id = "menu_tango_case", desc_id = "menu_tango_2_case_desc" }) }
  self.challenges[3].objectives = { tweak_data.safehouse:_progress("tango_3_case", 1, { name_id = "menu_tango_case", desc_id = "menu_tango_3_case_desc" }) }
  self.challenges[4].objectives = {
    tweak_data.safehouse:_progress("tango_4_key_1", 1, { name_id = "menu_tango_key_1", desc_id = "menu_tango_4_key_1_desc" }),
    tweak_data.safehouse:_progress("tango_4_key_2", 1, { name_id = "menu_tango_key_2", desc_id = "menu_tango_4_key_2_desc" })
  }
end)