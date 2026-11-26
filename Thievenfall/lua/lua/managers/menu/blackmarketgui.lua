local WEAPON_MODS_SLOTS = { 6, 1 }

Hooks:PostHook(BlackMarketGui, "show_stats", "CrimDusk_SetupBlackMarketGUI", function(self)
  if tweak_data.blackmarket.armors[self._slot_data.name] then
    local equipped_slot = managers.blackmarket:equipped_armor_slot()
    local equipped_item = managers.blackmarket:equipped_item(self._slot_data.category)
    local equip_base_stats, _, equip_skill_stats = self:_get_armor_stats(equipped_item)
    local base_stats, _, skill_stats = self:_get_armor_stats(self._slot_data.name)
    local value = math.max(base_stats.stamina.value + skill_stats.stamina.value, 0)

    if self._slot_data.name == equipped_slot then
      local base = base_stats.stamina.value

      if value ~= 0 and value > base then
        self._armor_stats_texts.stamina.equip:set_color(tweak_data.screen_colors.stats_negative)
      elseif value ~= 0 and value < base then
        self._armor_stats_texts.stamina.equip:set_color(tweak_data.screen_colors.stats_positive)
      else self._armor_stats_texts.stamina.equip:set_color(tweak_data.screen_colors.text) end

    else local equip = math.max(equip_base_stats.stamina.value + equip_skill_stats.stamina.value, 0)
      if value > equip then
        self._armor_stats_texts.stamina.total:set_color(tweak_data.screen_colors.stats_negative)
      elseif value < equip then
        self._armor_stats_texts.stamina.total:set_color(tweak_data.screen_colors.stats_positive)
      else self._armor_stats_texts.stamina.total:set_color(tweak_data.screen_colors.text) end
    end
  end
end)

Hooks:OverrideFunction(BlackMarketGui, "_get_armor_stats", function(self, name)
  local base_stats = {}
  local mods_stats = {}
  local skill_stats = {}
  local detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data({ armors = name}, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
  detection_risk = math.round(detection_risk * 100)
  local bm_armor_tweak = tweak_data.blackmarket.armors[name]
  local upgrade_level = bm_armor_tweak.upgrade_level
  local PresentMult = tweak_data.gui.stats_present_multiplier -- Converts values to be more presentable

  for i, stat in ipairs(self._armor_stats_shown) do
    base_stats[stat.name] = { value = 0 }
    mods_stats[stat.name] = { value = 0 }
    skill_stats[stat.name] = { value = 0 }

    if stat.name == "armor" then
      local base = (tweak_data.player.damage.ARMOR_INIT + managers.player:body_armor_value("armor", upgrade_level)) * PresentMult
      local addend = managers.player:body_armor_skill_addend(name) * PresentMult

      base_stats[stat.name] = { value = base }
      skill_stats[stat.name] = { value = (base * managers.player:body_armor_skill_multiplier(name)) + addend - base }

    elseif stat.name == "health" then
      local base = tweak_data.player.damage.HEALTH_INIT * PresentMult
      local addend = managers.player:health_skill_addend() * PresentMult

      base_stats[stat.name] = { value = base }
      skill_stats[stat.name] = { value = (base * managers.player:health_skill_multiplier()) + addend - base }

    elseif stat.name == "concealment" then
      base_stats[stat.name] = { value = managers.player:body_armor_value("concealment", upgrade_level) }
      skill_stats[stat.name] = { value = managers.blackmarket:concealment_modifier("armors", upgrade_level) }

		elseif stat.name == "movement" then
			local base = tweak_data.player.movement_state.standard.movement.speed.STANDARD_MAX / 100 * tweak_data.gui.stats_present_multiplier
			local movement_penalty = managers.player:body_armor_value("movement", upgrade_level)
			local base_value = movement_penalty * base
			base_stats[stat.name] = { value = base_value }
			local skill_mod = managers.player:movement_speed_multiplier(false, false, upgrade_level, 1)
			local val = base * skill_mod
			val = Utl.round(val, 2)
			base_value = Utl.round(base_value, 2)
			local skill_value = val - base_value
			skill_stats[stat.name] = { value = skill_value, skill_in_effect = skill_value > 0 }

		elseif stat.name == "dodge" then
			local base = 0
			local mod = managers.player:body_armor_value("dodge", upgrade_level)
			base_stats[stat.name] = { value = (base + mod) * 100 }
			skill_stats[stat.name] = { value = managers.player:skill_dodge_chance(false, false, false, name, detection_risk) * 100 }

		elseif stat.name == "crit" then
			local base = 0
			local mod = managers.player:body_armor_value("crit", upgrade_level)
			base_stats[stat.name] = { value = (base + mod) * 100 }
			skill_stats[stat.name] = { value = managers.player:critical_hit_chance(detection_risk) * 100 }

		elseif stat.name == "damage_shake" then
			local base = tweak_data.gui.armor_damage_shake_base
			local mod = math.max(managers.player:body_armor_value("damage_shake", upgrade_level, nil, 1), 0.01)
			local skill = math.max(managers.player:upgrade_value("player", "damage_shake_multiplier", 1), 0.01)
			local base_value = base
			local mod_value = base / mod - base_value
			local skill_value = base / mod / skill - base_value - mod_value + managers.player:upgrade_value("player", "damage_shake_addend", 0)
			base_stats[stat.name] = { value = (base_value + mod_value) * tweak_data.gui.stats_present_multiplier }
			skill_stats[stat.name] = { value = skill_value * tweak_data.gui.stats_present_multiplier }

    elseif stat.name == "stamina" then -- ARMOUR REGEN SPEED
      local base_value = Global.CrimDusk.regen_time[upgrade_level]
      local suppression = 0
      if upgrade_level <= 4 then suppression = 0.5 end

      local skill = managers.player:body_armor_regen_multiplier() * managers.player:upgrade_value("player", "armor_regen_time_mul", 1)
      if managers.player:upgrade_value("player", "armor_grinding", nil) ~= 0 then
        skill = 2
        base_value = base_value + suppression
        suppression = 0
      end

      local skill_value = base_value * skill
      if managers.player:upgrade_value("player", "passive_always_regen_armor", nil) ~= 0 and skill_value > 3 then
        skill_value = 3
        suppression = 0
      end

      base_stats[stat.name] = { value = base_value + suppression }
      skill_stats[stat.name] = { value = skill_value - base_value }
    end

    skill_stats[stat.name].skill_in_effect = skill_stats[stat.name].skill_in_effect or skill_stats[stat.name].value ~= 0
  end

  if managers.player:has_category_upgrade("player", "armor_to_health_conversion") then
    local conversion_ratio = managers.player:upgrade_value("player", "armor_to_health_conversion") * 0.01
    local converted_armor = (base_stats.armor.value + skill_stats.armor.value) * conversion_ratio
    local skill_in_effect = converted_armor ~= 0
    skill_stats.armor.value = skill_stats.armor.value - converted_armor
    skill_stats.health.value = skill_stats.health.value + converted_armor
    skill_stats.armor.skill_in_effect = skill_in_effect
    skill_stats.health.skill_in_effect = skill_in_effect
  end

  return base_stats, mods_stats, skill_stats
end)

Hooks:OverrideFunction(BlackMarketGui, "populate_mods", function(self, data)
  local new_data = {}
  local default_mod = data.on_create_data.default_mod
  local crafted = managers.blackmarket:get_crafted_category(data.prev_node_data.category)[data.prev_node_data.slot]
  local global_values = crafted.global_values or {}
  local ids_id = Idstring(data.name)
  local weapon_factory_tweak = tweak_data.weapon.factory.parts
  local cosmetic_kit_mod
  local cosmetics_blueprint = crafted.cosmetics and managers.weapon_factory:get_cosmetics_blueprint_by_weapon_id(crafted.weapon_id, crafted.cosmetics.id) or {}

  for i, c_mod in ipairs(cosmetics_blueprint) do
    if Idstring(weapon_factory_tweak[c_mod].type) == ids_id then cosmetic_kit_mod = c_mod break end
  end

  local old_num = #data

  for i = 1, old_num do data[i] = nil end

  local gvs = {}
  local mod_t = {}
  local num_steps = #data.on_create_data
  local achievement_tracker = tweak_data.achievement.weapon_part_tracker
  local part_is_from_cosmetic, mod_tweak, dlc_global_value, dlc_global_value_tweak, dlc_unlock_id, is_dlc_unlocked
  local guis_catalog = "guis/"
  local index = 1

  for i, mod_t in ipairs(data.on_create_data) do
    local mod_name = mod_t[1]
    local mod_default = mod_t[2]
    local mod_global_value = mod_t[3] or "normal"

    part_is_from_cosmetic = cosmetic_kit_mod == mod_name
    mod_tweak = tweak_data.blackmarket.weapon_mods[mod_name]
    guis_catalog = "guis/"

    local bundle_folder = mod_tweak and mod_tweak.texture_bundle_folder

    if bundle_folder then guis_catalog = guis_catalog .. "dlcs/" .. tostring(bundle_folder) .. "/" end

    new_data = {
      name = mod_name or data.prev_node_data.name,
      name_localized = mod_name and managers.weapon_factory:get_part_name_by_part_id(mod_name) or managers.localization:text("bm_menu_no_mod"),
      category = data.category or data.prev_node_data and data.prev_node_data.category
    }

    new_data.bitmap_texture = guis_catalog .. "textures/pd2/blackmarket/icons/mods/" .. new_data.name
    new_data.slot = data.slot or data.prev_node_data and data.prev_node_data.slot
    new_data.global_value = mod_global_value
    new_data.equipped = false
    new_data.stream = true
    new_data.default_mod = default_mod
    new_data.cosmetic_kit_mod = cosmetic_kit_mod
    new_data.is_internal = tweak_data.weapon.factory:is_part_internal(new_data.name)
    new_data.free_of_charge = part_is_from_cosmetic or mod_tweak and mod_tweak.is_a_unlockable
    new_data.unlock_tracker = achievement_tracker[new_data.name] or false
    new_data.dlc = new_data.global_value and managers.dlc:global_value_to_dlc(new_data.global_value)
    new_data.unlock_dlc = mod_tweak and mod_tweak.unlock_dlc or new_data.dlc

    if crafted.customize_locked then
      if type(crafted.customize_locked) == "boolean" then
        new_data.unlocked = not crafted.customize_locked

        if crafted.customize_locked then
          new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"
          new_data.dlc_locked = "bm_menu_cosmetic_locked_weapon"
        end

      else
        local part_type = weapon_factory_tweak[new_data.name].type
        local part_locked = crafted.customize_locked[part_type]

        if part_locked then
          new_data.dlc_locked = "bm_menu_cosmetic_locked_weapon"
          new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"

          local cosmetic_tweakdata = tweak_data.blackmarket.weapon_skins[crafted.cosmetics.id]
          local color = tweak_data.economy.rarities[cosmetic_tweakdata.rarity or "legendary"].color

          new_data.lock_color = color
          new_data.unlocked = false

        else
          new_data.unlocked = part_is_from_cosmetic and 1 or mod_default or managers.blackmarket:get_item_amount(new_data.global_value, "weapon_mods", new_data.name, true)
        end
      end

    else
      new_data.unlocked = part_is_from_cosmetic and 1 or mod_default or managers.blackmarket:get_item_amount(new_data.global_value, "weapon_mods", new_data.name, true)
    end

    is_dlc_unlocked = not new_data.dlc or managers.dlc:is_dlc_unlocked(new_data.dlc)
    new_data.hide_unavailable = not is_dlc_unlocked and managers.dlc:should_hide_unavailable(new_data.dlc)
    dlc_global_value = nil
    dlc_global_value_tweak = nil
    dlc_unlock_id = nil

    if not part_is_from_cosmetic and not is_dlc_unlocked then
      dlc_global_value = new_data.unlock_dlc and managers.dlc:dlc_to_global_value(new_data.unlock_dlc)
      dlc_global_value_tweak = dlc_global_value and tweak_data.lootdrop.global_values[dlc_global_value]
      dlc_unlock_id = dlc_global_value_tweak and tweak_data.lootdrop.global_values[dlc_global_value].unlock_id or managers.dlc:get_unavailable_id(new_data.global_value)
      new_data.dlc_locked = new_data.hide_unavailable and managers.dlc:get_unavailable_id(new_data.global_value) or dlc_unlock_id
      new_data.lock_texture = self:get_lock_icon(new_data)
      new_data.lock_color = self:get_lock_color(new_data)
      new_data.unlocked = type(new_data.unlocked) == "number" and -math.abs(new_data.unlocked) or new_data.unlocked
      new_data.unlocked = new_data.unlocked ~= 0 and new_data.unlocked or false

    else
      local event_job_challenge = managers.event_jobs:get_challenge_from_reward("weapon_mods", new_data.name)

      if event_job_challenge and not event_job_challenge.completed then
        new_data.unlocked = type(new_data.unlocked) == "number" and -math.abs(new_data.unlocked) or new_data.unlocked
        new_data.lock_texture = "guis/textures/pd2/lock_achievement"
        new_data.dlc_locked = event_job_challenge.locked_id or "menu_event_job_lock_info"
      end

    end

    local weapon_id = managers.blackmarket:get_crafted_category(new_data.category)[new_data.slot].weapon_id

    new_data.price = part_is_from_cosmetic and 0 or managers.money:get_weapon_modify_price(weapon_id, new_data.name, new_data.global_value)
    new_data.can_afford = part_is_from_cosmetic or managers.money:can_afford_weapon_modification(weapon_id, new_data.name, new_data.global_value)

    local font, font_size
    local no_upper = false

    if crafted.previewing then
      new_data.previewing = true
      new_data.corner_text = {}
      new_data.corner_text.selected_text = managers.localization:text("bm_menu_mod_preview")
      new_data.corner_text.noselected_text = new_data.corner_text.selected_text
      new_data.corner_text.noselected_color = Color.white

    elseif not new_data.lock_texture and (not new_data.unlocked or new_data.unlocked == 0) then
      if managers.dlc:is_content_achievement_locked("weapon_mods", new_data.name) or managers.dlc:is_content_achievement_milestone_locked("weapon_mods", new_data.name) then
        new_data.lock_texture = "guis/textures/pd2/lock_achievement"

      elseif managers.dlc:is_content_skirmish_locked("weapon_mods", new_data.name) then
        new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"

      elseif managers.dlc:is_content_crimespree_locked("weapon_mods", new_data.name) then
        new_data.lock_texture = "guis/textures/pd2/skilltree/padlock"

      elseif managers.dlc:is_content_infamy_locked("weapon_mods", new_data.name) then
        new_data.lock_texture = "guis/textures/pd2/lock_infamy"
        new_data.dlc_locked = "menu_infamy_lock_info"

      else
        local event_job_challenge = managers.event_jobs:get_challenge_from_reward("weapon_mods", new_data.name)
        if event_job_challenge and not event_job_challenge.completed then
          new_data.unlocked = -math.abs(new_data.unlocked)
          new_data.lock_texture = "guis/textures/pd2/lock_achievement"
          new_data.dlc_locked = event_job_challenge.locked_id or "menu_event_job_lock_info"

        else
          local selected_text = managers.localization:text("bm_menu_no_items")
          new_data.corner_text = {}
          new_data.corner_text.selected_text = selected_text
          new_data.corner_text.noselected_text = selected_text
        end
      end

    elseif new_data.unlocked and not new_data.can_afford then
      new_data.corner_text = {}
      new_data.corner_text.selected_text = managers.localization:text("bm_menu_not_enough_cash")
      new_data.corner_text.noselected_text = new_data.corner_text.selected_text
    end

    local forbid
    if mod_name then
      forbid = managers.blackmarket:can_modify_weapon(new_data.category, new_data.slot, new_data.name)

      if forbid then
        if type(new_data.unlocked) == "number" then new_data.unlocked = -math.abs(new_data.unlocked)
        else new_data.unlocked = false end
        new_data.lock_texture = self:get_lock_icon(new_data, "guis/textures/pd2/lock_incompatible")
        new_data.mid_text = nil
        new_data.conflict = managers.localization:text("bm_menu_" .. tostring(weapon_factory_tweak[forbid] and weapon_factory_tweak[forbid].type or forbid))
      end

      local replaces, removes = managers.blackmarket:get_modify_weapon_consequence(new_data.category, new_data.slot, new_data.name)
      new_data.removes = removes or {}

      local weapon = managers.blackmarket:get_crafted_category_slot(data.prev_node_data.category, data.prev_node_data.slot) or {}
      local gadget
      local mod_td = weapon_factory_tweak[new_data.name]
      local mod_type = mod_td.type
      local sub_type = mod_td.sub_type
      local is_auto = weapon and tweak_data.weapon[weapon.weapon_id] and tweak_data.weapon[weapon.weapon_id].FIRE_MODE == "auto"

      if mod_type == "gadget" then gadget = sub_type end

      local silencer = sub_type == "silencer" and true
      local texture = managers.menu_component:get_texture_from_mod_type(mod_type, sub_type, gadget, silencer, is_auto)

      new_data.desc_mini_icons = {}

      if DB:has(Idstring("texture"), texture) then
        table.insert(new_data.desc_mini_icons, { bottom = 0, h = 16, right = 0, w = 16, texture = texture })
      end

      local is_gadget = false
      local show_stats = not new_data.conflict and new_data.unlocked and not is_gadget and not new_data.dlc_locked and weapon_factory_tweak[new_data.name].type ~= "charm"
      if show_stats then new_data.comparision_data = managers.blackmarket:get_weapon_stats_with_mod(new_data.category, new_data.slot, mod_name) end

      if managers.blackmarket:got_new_drop(mod_global_value, "weapon_mods", mod_name) then
        new_data.mini_icons = new_data.mini_icons or {}
        table.insert(new_data.mini_icons, {
          h = 16, top = 0, w = 16, right = 0, layer = 1,
          name = "new_drop", stream = false,
          texture = "guis/textures/pd2/blackmarket/inv_newdrop"
        })
        new_data.new_drop_data = { new_data.global_value or "normal", "weapon_mods", mod_name }
      end
    end

    local active = true
    local can_apply = not crafted.previewing
    local mod_type = weapon_factory_tweak[new_data.name].type
    local preview_forbidden = managers.blackmarket:is_previewing_legendary_skin(mod_type) or managers.blackmarket:preview_mod_forbidden(new_data.category, new_data.slot, new_data.name)
    local is_customize_locked = false

    if crafted.customize_locked then
      if type(crafted.customize_locked) == "boolean" then is_customize_locked = crafted.customize_locked
      else
        local part_type = weapon_factory_tweak[new_data.name].type
        local part_locked = crafted.customize_locked[part_type]
        if part_locked then is_customize_locked = true end
      end
    end

    if mod_name and not is_customize_locked and active then
      if new_data.unlocked and (type(new_data.unlocked) ~= "number" or new_data.unlocked > 0) and can_apply then
        if new_data.can_afford then table.insert(new_data, "wm_buy") end

        if managers.blackmarket:is_previewing_any_mod() then table.insert(new_data, "wm_clear_mod_preview") end

        if not new_data.is_internal and not preview_forbidden then
          if managers.blackmarket:is_previewing_mod(new_data.name) then table.insert(new_data, "wm_remove_preview")
          else table.insert(new_data, "wm_preview_mod") end
        end

      else
        local dlc_data = dlc_global_value and Global.dlc_manager.all_dlc_data[dlc_global_value]
        dlc_data = dlc_data or Global.dlc_manager.all_dlc_data[new_data.global_value]

        if dlc_data and dlc_data.app_id and not dlc_data.external and not managers.dlc:is_dlc_unlocked(new_data.global_value) then
          table.insert(new_data, "bw_buy_dlc")
        end

        if managers.blackmarket:is_previewing_any_mod() then table.insert(new_data, "wm_clear_mod_preview") end

        if not new_data.is_internal and not preview_forbidden then
          if managers.blackmarket:is_previewing_mod(new_data.name) then table.insert(new_data, "wm_remove_preview")
          else table.insert(new_data, "wm_preview_mod") end
        end
      end

      if managers.workshop and managers.workshop:enabled() and not table.contains(managers.blackmarket:skin_editor():get_excluded_weapons(), weapon_id) then
        table.insert(new_data, "w_skin")
      end

      -- Can unlock weapon mods
      if new_data.unlocked == 0 and not new_data.dlc_locked then
        local weapon_mod_tweak = weapon_factory_tweak[mod_name]
        if weapon_mod_tweak and can_apply then
          table.insert(new_data, "wm_buy_mod")
        end
      end
    end

    data[index] = new_data
    index = index + 1
  end

  for i = 1, math.max(math.ceil(num_steps / WEAPON_MODS_SLOTS[1]), WEAPON_MODS_SLOTS[2]) * WEAPON_MODS_SLOTS[1] do
    if not data[i] then
      new_data = {}
      new_data.name = "empty"
      new_data.name_localized = ""
      new_data.category = data.category
      new_data.slot = i
      new_data.unlocked = true
      new_data.equipped = false
      data[i] = new_data
    end
  end

  local weapon_blueprint = managers.blackmarket:get_weapon_blueprint(data.prev_node_data.category, data.prev_node_data.slot) or {}
  local equipped

  local function update_equipped()
    if equipped then
      local equipped_data = data[equipped]
      local is_customize_locked = false

      if crafted.customize_locked then
        if type(crafted.customize_locked) == "boolean" then is_customize_locked = crafted.customize_locked
        else
          local weapon_factory_tweak = tweak_data.weapon.factory.parts
          local part_type = weapon_factory_tweak[equipped_data.name].type
          local part_locked = crafted.customize_locked[part_type]
          if part_locked then is_customize_locked = true end
        end
      end

      equipped_data.equipped = true
      equipped_data.unlocked = not is_customize_locked and (equipped_data.unlocked or true)
      equipped_data.mid_text = is_customize_locked and (equipped_data.mid_text or nil)
      equipped_data.lock_texture = is_customize_locked and (equipped_data.lock_texture or nil)
      equipped_data.corner_text = is_customize_locked and (equipped_data.corner_text or nil)

      for i = 1, #equipped_data do table.remove(equipped_data, 1) end

      equipped_data.price = 0
      equipped_data.can_afford = true

      if not is_customize_locked then
        table.insert(equipped_data, "wm_remove_buy")

        if not equipped_data.is_internal then
          local mod_type = weapon_factory_tweak[equipped_data.name].type
          local preview_forbidden = managers.blackmarket:is_previewing_legendary_skin(mod_type) or managers.blackmarket:preview_mod_forbidden(equipped_data.category, equipped_data.slot, equipped_data.name)

          if managers.blackmarket:is_previewing_any_mod() then table.insert(equipped_data, "wm_clear_mod_preview") end
          if managers.blackmarket:is_previewing_mod(equipped_data.name) then table.insert(equipped_data, "wm_remove_preview")
          elseif not preview_forbidden then table.insert(equipped_data, "wm_preview_mod") end

        else
          table.insert(equipped_data, "wm_preview")
        end

        if managers.workshop and managers.workshop:enabled() and data.prev_node_data and not table.contains(managers.blackmarket:skin_editor():get_excluded_weapons(), data.prev_node_data.name) then
          table.insert(equipped_data, "w_skin")
        end

        local weapon_mod_tweak = weapon_factory_tweak[equipped_data.name]
        if weapon_mod_tweak and weapon_mod_tweak.type ~= "bonus" and weapon_mod_tweak.is_a_unlockable ~= true and managers.custom_safehouse:unlocked() then
          table.insert(equipped_data, "wm_buy_mod")
        end
      end

      local factory = weapon_factory_tweak[equipped_data.name]
      local is_correct_type = data.name == "sight" or data.name == "gadget" or data.name == "second_sight"

      if is_correct_type and factory and factory.texture_switch then
        table.insert(equipped_data, "wm_reticle_switch_menu")
        local reticle_texture = managers.blackmarket:get_part_texture_switch(equipped_data.category, equipped_data.slot, equipped_data.name)
        if reticle_texture and reticle_texture ~= "" then
          equipped_data.mini_icons = equipped_data.mini_icons or {}
          table.insert(equipped_data.mini_icons, {
            blend_mode = "add", bottom = 1, h = 30, layer = 2, right = 1, w = 30,
            stream = true, texture = reticle_texture
          })
        end
      end

      local gmod_name = equipped_data.name
      local gmod_td = weapon_factory_tweak[gmod_name]
      local has_customizable_gadget = (data.name == "gadget" or table.contains(gmod_td.perks or {}, "gadget")) and (gmod_td.sub_type == "laser" or gmod_td.sub_type == "flashlight")
      if not has_customizable_gadget and gmod_td.adds then
        for _, part_id in ipairs(gmod_td.adds) do
          local sub_type = weapon_factory_tweak[part_id].sub_type
          if sub_type == "laser" or sub_type == "flashlight" then has_customizable_gadget = true break end
        end
      end

      if has_customizable_gadget then
        table.insert(equipped_data, "wm_customize_gadget")
        local secondary_sub_type = false
        if gmod_td.adds then
          for _, part_id in ipairs(gmod_td.adds) do
            local sub_type = tweak_data.weapon.factory.parts[part_id].sub_type
            if sub_type == "laser" or sub_type == "flashlight" then secondary_sub_type = sub_type break end
          end
        end

        local colors = managers.blackmarket:get_part_custom_colors(equipped_data.category, equipped_data.slot, gmod_name)

        if colors then
          equipped_data.mini_colors = {}
          if gmod_td.sub_type then
            table.insert(equipped_data.mini_colors, {
              blend = "add", alpha = tweak_data.custom_colors.defaults.laser_alpha,
              color = colors[gmod_td.sub_type] or tweak_data.custom_colors.defaults.laser
            })
          end

          if secondary_sub_type then
            table.insert(equipped_data.mini_colors, {
              blend = "add", alpha = tweak_data.custom_colors.defaults.laser_alpha,
              color = colors[secondary_sub_type] or tweak_data.custom_colors.defaults.laser
            })
          end
        end
      end
    end
  end

  for i, mod in ipairs(data) do
    for _, weapon_mod in ipairs(weapon_blueprint) do
      if mod.name == weapon_mod and (not global_values[weapon_mod] or global_values[weapon_mod] == data[i].global_value) then
        equipped = i
      break end
    end
  end

  update_equipped()
end)