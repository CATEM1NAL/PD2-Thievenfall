local FileIdent = "SafehouseTweakData"

Hooks:PostHook(CustomSafehouseTweakData, "_init_map", "CrimDusk_InitSafehouseMap", function(self)
  local perma = CrimDusk.IsPermadeath()
  for floor, _ in ipairs(self.map.floors) do
    for i = #self.map.floors[floor].rooms, 1, -1 do

      local HoxtonArrested = perma == "_perma" or Global.CrimDusk.data.heists_won > 4
      if self.map.floors[floor].rooms[i] == "old_hoxton" and (HoxtonArrested and Global.CrimDusk.data["free_hoxton" .. perma] < 4) then
        CrimDusk.Log(FileIdent, "Locking Hoxton's room...", true)
        table.remove(self.map.floors[floor].rooms, i)

      elseif self.map.floors[floor].rooms[i] == "wild" and not Global.CrimDusk.data["rust_recruited" .. perma] then
        CrimDusk.Log(FileIdent, "Locking Rust's room...", true)
        table.remove(self.map.floors[floor].rooms, i)
      end

    end
  end
end)

Hooks:PostHook(CustomSafehouseTweakData, "_init_trophies", "CrimDusk_InitTrophies", function(self)
  for _, trophy in ipairs(self.trophies) do
    if trophy.id == "trophy_bains_book" then trophy.objectives = { self:_achievement("nmh_7") }
    elseif trophy.id == "trophy_box_3" then trophy.objectives = { self:_achievement("des_7") }
    elseif trophy.id == "trophy_black_plate" then trophy.objectives = { self:_achievement("sah_7") }
    elseif trophy.id == "trophy_brb_1" then trophy.objectives = { self:_achievement("brb_7") }
    elseif trophy.id == "trophy_box_2" then trophy.objectives = { self:_achievement("tag_7") }
    elseif trophy.id == "trophy_computer" then trophy.objectives = { self:_achievement("gage2_1") }
    elseif trophy.id == "trophy_smwish" then trophy.objectives = { self:_achievement("vit_8") }
    elseif trophy.id == "trophy_dozer_helmet" then trophy.objectives = { self:_progress("trophy_special_kills", 1000, { name_id = "trophy_dozer_helmet_progress" }) }
    elseif trophy.id == "trophy_dartboard" then trophy.objectives = { self:_progress("trophy_headshots", 10000, { name_id = "trophy_dartboard_progress" }) }
    elseif trophy.id == "trophy_host" then
      trophy.show_progress = nil
      trophy.objectives = { self:_progress("trophy_host", 1) }

    elseif trophy.id == "trophy_goat" then
      trophy.show_progress = nil
      trophy.objectives = { self:_achievement("ggez_45") }

    elseif trophy.id == "trophy_hockey_team" then
      trophy.show_progress = true
      trophy.objectives = { self:_progress("trophy_hockeykill", 100, { name_id = "trophy_hockeykill_progress" }) }

    elseif trophy.id == "trophy_ace" then
      trophy.show_progress = nil
      trophy.objectives = { self:_progress("trophy_ace", 1) }

    elseif trophy.id == "trophy_box_1" then
      trophy.show_progress = true
      trophy.objectives = { self:_achievement("ggez_46", { name_id = "heist_kenaz_full" }), self:_achievement("des_7", { name_id = "heist_des" }) }

    elseif trophy.id == "trophy_fbi" then
      trophy.show_progress = true
      trophy.objectives = {
        self:_progress("trophy_fbi_tag", 1, { name_id = "heist_tag" }),
        self:_progress("trophy_fbi", 1, { name_id = "heist_firestarter_2_hl" }),
        self:_progress("trophy_fbi_hox", 1, { name_id = "heist_hox_2_hl" })
      }

    elseif trophy.id == "trophy_pacifier" then
      trophy.objectives = {
        self:_progress("trophy_basics_stealth", 1, { name_id = "heist_short1_stage1_hl" }),
        self:_progress("trophy_basics_stealth_2", 1, { name_id = "heist_short1_stage2_hl" }),
        self:_progress("trophy_basics_loud", 1, { name_id = "heist_short2_stage1_hl" })
      }

    elseif trophy.id == "trophy_stealth" then
      trophy.objectives = {
        self:_progress("trophy_stealth_gallery", 1, { name_id = "heist_gallery" }), -- Art Gallery
        self:_progress("trophy_stealth_chca", 1, { name_id = "heist_chca" }), -- Black Cat
        self:_progress("trophy_stealth_crojob1", 1, { name_id = "heist_crojob1" }), -- Bomb: Dockyard
        self:_progress("trophy_stealth_tag", 1, { name_id = "heist_tag" }), -- Breakin' Feds
        self:_progress("trophy_stealth_cage", 1, { name_id = "heist_cage" }), -- Car Shop
        self:_progress("trophy_stealth_dah", 1, { name_id = "heist_dah" }), -- Diamond Heist
        self:_progress("trophy_stealth_family", 1, { name_id = "heist_family" }), -- Diamond Store
        self:_progress("trophy_stealth_cd_firestarter2", 1, { name_id = "heist_firestarter_2_hl" }), -- FBI Server
        self:_progress("trophy_stealth_four_stores", 1, { name_id = "heist_four_stores" }), -- Four Stores
        self:_progress("trophy_stealth_cd_frame3", 1, { name_id = "heist_framing_frame_3_hl" }), -- Framing
        self:_progress("trophy_stealth_kenaz", 1, { name_id = "heist_kenaz_full" }), -- Golden Grin
        self:_progress("trophy_stealth_dark", 1, { name_id = "heist_dark" }), -- Murky Station
        self:_progress("trophy_stealth_nmh", 1, { name_id = "heist_nmh" }), -- No Mercy
        self:_progress("trophy_stealth_kosugi", 1, { name_id = "heist_kosugi" }), -- Shadow Raid
        self:_progress("trophy_stealth_cd_erection1", 1, { name_id = "heist_election_day_2_hl" }), -- Swing Vote
        self:_progress("trophy_stealth_fish", 1, { name_id = "heist_fish" }) -- Yacht Heist
      }

    elseif trophy.id == "trophy_transports" then
      trophy.objectives = {
        self:_progress("trophy_transport_crossroads", 1, { name_id = "heist_arm_cro" }),
        self:_progress("trophy_transport_downtown", 1, { name_id = "heist_arm_hcm" }),
        self:_progress("trophy_transport_harbor", 1, { name_id = "heist_arm_fac" }),
        self:_progress("trophy_transport_park", 1, { name_id = "heist_arm_par" }),
        self:_progress("trophy_transport_underpass", 1, { name_id = "heist_arm_und" })
      }
    end
  end
end)