Hooks:PostHook(EventJobsTweakData, "init", "CrimDusk_InitSideJobTweak", function(self, tweak_data)
  local CopyCat
  for i, job in ipairs(self.challenges) do
    if job.id == "pda8_2" then job.objectives = { self:_collective("pda8_collective", 3, { name_id = "menu_pda8_2_prog_obj", desc_id = "menu_pda8_2_prog_obj_desc" }) }
    elseif job.id == "pda8_3" then job.objectives = { self:_collective("pda8_collective", 5, { name_id = "menu_pda8_3_prog_obj", desc_id = "menu_pda8_3_prog_obj_desc" }) }
    elseif job.id == "pda8_4" then
      table.remove(job.objectives, 1)
      table.remove(job.objectives, #job.objectives)
      job.objectives[1].desc_id = "menu_pda8_item_1_desc"

    elseif job.id == "pda9_community_1" then job.objectives = { tweak_data.safehouse:_progress("pda9_n1", 1, { name_id = "menu_pda9_item_n1", desc_id = "menu_pda9_item_n1_desc" }) }
    elseif job.id == "pda9_community_2" then job.objectives = { tweak_data.safehouse:_progress("pda9_n2", 99, { name_id = "menu_pda9_item_n2", desc_id = "menu_pda9_item_n2_desc" }) }
    elseif job.id == "pda9_community_3" then job.objectives = { tweak_data.safehouse:_progress("pda9_n3", 9999, { name_id = "menu_pda9_item_n3",desc_id = "menu_pda9_item_n3_desc" }) }
    elseif job.id == "pda9_community_4" then job.objectives = { tweak_data.safehouse:_progress("pda9_n4", 99, { name_id = "menu_pda9_item_n4", desc_id = "menu_pda9_item_n4_desc" }) }
    elseif job.id == "pda9_community_5" then job.objectives = { tweak_data.safehouse:_progress("pda9_n5", 9, { name_id = "menu_pda9_item_n5", desc_id = "menu_pda9_item_n5_desc" }) }
    elseif job.id == "cg22_1" then job.objectives = {
      self:_choice({
        tweak_data.safehouse:_progress("cg22_personal_1", 50, { name_id = "menu_cg22_personal_1", desc_id = "menu_cg22_personal_1_desc" }),
        tweak_data.safehouse:_progress("cg22_post_objective_1", 500, { name_id = "menu_cg22_post_objective_1", desc_id = "menu_cg22_post_objective_1_desc" })
      }, 1, { choice_id = "cg22_personal_1", name_id = "menu_cg22_1_choice_obj", desc_id = "menu_cg22_post_objective_1_desc" })
    }
    elseif job.id == "cg22_2" then job.objectives = {
      self:_choice({
        tweak_data.safehouse:_progress("cg22_personal_2", 5000, { name_id = "menu_cg22_personal_2", desc_id = "menu_cg22_personal_2_desc" }),
        tweak_data.safehouse:_progress("cg22_post_objective_2", 5, { name_id = "menu_cg22_post_objective_2", desc_id = "menu_cg22_post_objective_2_desc" })
      }, 1, { choice_id = "cg22_personal_2", name_id = "menu_cg22_2_choice_obj", desc_id = "menu_cg22_post_objective_2_desc" })
    }
    elseif job.id == "cg22_3" then job.objectives = {
      self:_choice({
        tweak_data.safehouse:_progress("cg22_personal_3", 500, { name_id = "menu_cg22_personal_3", desc_id = "menu_cg22_personal_3_desc" }),
        tweak_data.safehouse:_progress("cg22_post_objective_3", 1000, { name_id = "menu_cg22_post_objective_3", desc_id = "menu_cg22_post_objective_3_desc" })
      }, 1, { choice_id = "cg22_personal_3", name_id = "menu_cg22_3_choice_obj", desc_id = "menu_cg22_post_objective_3_desc" })
    }
    elseif job.id == "cg22_community_1" then job.objectives = { tweak_data.safehouse:_progress("cg22_post_objective_4", 100, { name_id = "menu_cg22_post_objective_4", desc_id = "menu_cg22_post_objective_4_desc" }) }
    elseif job.id == "cg22_community_2" then job.objectives = { tweak_data.safehouse:_progress("cg22_post_objective_5", 100, { name_id = "menu_cg22_post_objective_5", desc_id = "menu_cg22_post_objective_5_desc" }) }
    elseif job.id == "cg22_community_3" then job.objectives = { tweak_data.safehouse:_progress("cg22_post_objective_4", 250, { name_id = "menu_cg22_post_objective_6", desc_id = "menu_cg22_post_objective_6_desc" }) }
    elseif job.id == "cg22_community_4" then CopyCat = i
    elseif job.id == "cg22_community_5" then job.objectives = { tweak_data.safehouse:_progress("cg22_post_objective_5", 500, { name_id = "menu_cg22_post_objective_8", desc_id = "menu_cg22_post_objective_8_desc" }) }
    elseif job.id == "cg22_community_6" then job.objectives = { tweak_data.safehouse:_progress("cg22_post_objective_4", 500, { name_id = "menu_cg22_post_objective_9", desc_id = "menu_cg22_post_objective_9_desc" }) }
    elseif job.id == "pda10_3" then job.objectives = { tweak_data.safehouse:_progress("pda10_heist_post_objective", 50, { name_id = "menu_pda10_post_objective_3", desc_id = "menu_pda10_post_objective_3_desc" }) }
    elseif job.id == "pda10_5" then job.objectives = {
      self:_choice({
        tweak_data.safehouse:_progress("pda10_musket_objective", 50, { name_id = "menu_pda10_personal_5", desc_id = "menu_pda10_personal_5_desc" }),
        tweak_data.safehouse:_progress("pda10_musket_post_objective", 1000, { name_id = "menu_pda10_post_objective_5", desc_id = "menu_pda10_post_objective_5_desc" })
      }, 1, { choice_id = "pda10_personal_5", name_id = "menu_pda10_5_choice_obj", desc_id = "menu_pda10_post_objective_5_desc" })
    }

    elseif job.id == "pda10_2" then job.objectives = { tweak_data.safehouse:_progress("pda10_bags_post_objective", 50, { name_id = "menu_pda10_post_objective_2", desc_id = "menu_pda10_post_objective_2_desc" }) }
    elseif job.id == "pda10_6" then job.objectives = {
      self:_choice({
        tweak_data.safehouse:_progress("pda10_hammer_objective", 100, { name_id = "menu_pda10_personal_6", desc_id = "menu_pda10_personal_6_desc" }),
        tweak_data.safehouse:_progress("pda10_hammer_post_objective", 500, { name_id = "menu_pda10_post_objective_6", desc_id = "menu_pda10_post_objective_6_desc" })
      }, 1, { choice_id = "pda10_personal_6", name_id = "menu_pda10_6_choice_obj", desc_id = "menu_pda10_post_objective_6_desc" })
    }

    elseif job.id == "pda10_1" then job.objectives = { tweak_data.safehouse:_progress("pda10_dozer_post_objective", 250, { name_id = "menu_pda10_post_objective_1", desc_id = "menu_pda10_post_objective_1_desc" }) }
    elseif job.id == "pda10_4" then job.objectives = { tweak_data.safehouse:_progress("pda10_buff_post_objective", 500, { name_id = "menu_pda10_post_objective_4", desc_id = "menu_pda10_post_objective_4_desc" }) }
    end
  end

  table.remove(self.challenges, CopyCat)
end)