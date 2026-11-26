Hooks:PostHook(GuiTweakData, "init", "CrimDusk_InitGuiTweak", function(self)
  self.crime_net.job_vars.max_active_jobs = 1
  self.crime_net.job_vars.active_job_time = 86400

  self.crime_net.sidebar = {
    { name_id = "menu_cn_shortcuts", icon = "sidebar_expand", callback = "clbk_toggle_sidebar", show_name_while_collapsed = false },
    { name_id = "menu_cn_filters_sidebar", icon = "sidebar_filters", callback = "clbk_crimenet_filters", btn_macro = "menu_toggle_filters", visible_callback = "clbk_visible_multiplayer" },
    { id = "search_lobby_code", name_id = "menu_cn_search_lobby_code", icon = "sidebar_lobby_search", callback = "clbk_search_lobby_code", visible_callback = "clbk_visible_multiplayer_epic_mm" },

    { item_class = "CrimeNetSidebarSeparator" },

    { id = "safehouse", name_id = "menu_cn_chill", icon = "sidebar_safehouse", callback = "clbk_safehouse", item_class = "CrimeNetSidebarSafehouseItem" },
    { id = "skirmish", name_id = "menu_weekly_skirmish", icon = "sidebar_skirmish", callback = "clbk_setup_weekly_holdout", item_class = "CrimeNetSidebarSkirmishItem" },

    { item_class = "CrimeNetSidebarSeparator" },

    { name_id = "menu_cn_side_jobs", icon = "sidebar_side_jobs", callback = "clbk_side_jobs" },
    { name_id = "menu_cn_gage_assignment", icon = "sidebar_gage", callback = "clbk_gage_courier" },
    { name_id = "menu_cn_casino", icon = "sidebar_casino", callback = "clbk_offshore_payday" },
    { name_id = "menu_cn_contact_info", icon = "sidebar_codex", callback = "clbk_contact_database" },

    --{ item_class = "CrimeNetSidebarSeparator", visible_callback = "clbk_new_weekly_holdout" },
    --{ id = "crime_spree", name_id = "cn_crime_spree", icon = "sidebar_crimespree", callback = "clbk_crime_spree", item_class = "CrimeNetSidebarCrimeSpreeItem", visible_callback = "clbk_visible_crime_spree" },
    -- No plans to implement crime spree right now, because, like, what the fuck would it even be???
  }
end)