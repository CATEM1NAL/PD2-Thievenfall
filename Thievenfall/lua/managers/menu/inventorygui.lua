-- Remove perk decks
Hooks:OverrideFunction(PlayerInventoryGui, "open_specialization_menu", function() managers.menu:open_node("skilltree_new", {}) end)
Hooks:PreHook(PlayerInventoryGui, "sort_boxes_by_matrix", "CrimDusk_DeletePerksInventoryGUI", function(self)
  self:remove_box(self._boxes_by_name.specialization)
end)

local function format_round(num, round_value)
	return round_value and tostring(math.round(num)) or string.format("%.1f", num):gsub("%.?0+$", "")
end

-- The original function does a bunch of unneccessary shit, so I got annoyed and replaced it.
Hooks:OverrideFunction(PlayerInventoryGui, "_update_player_stats", function(self)
  local base_stats, _, skill_stats = self:_get_armor_stats(managers.blackmarket:equipped_item("armors"))

  for _, stat in ipairs(self._player_stats_shown) do
    local value = math.max(base_stats[stat.name].value + skill_stats[stat.name].value, 0)
    local base = base_stats[stat.name].value

    self._player_stats_texts[stat.name].total:set_alpha(1)
    self._player_stats_texts[stat.name].total:set_text(format_round(value, stat.round_value))
    self._player_stats_texts[stat.name].base:set_text(format_round(base, stat.round_value))
    self._player_stats_texts[stat.name].skill:set_text(skill_stats[stat.name].skill_in_effect and (skill_stats[stat.name].value > 0 and "+" or "") .. format_round(skill_stats[stat.name].value, stat.round_value) or "")

    if value ~= 0 and base < value then
      local colour = stat.name ~= "stamina" and tweak_data.screen_colors.stats_positive or tweak_data.screen_colors.stats_negative
      self._player_stats_texts[stat.name].total:set_color(colour)

    elseif value ~= 0 and value < base then
      local colour = stat.name ~= "stamina" and tweak_data.screen_colors.stats_negative or tweak_data.screen_colors.stats_positive
      self._player_stats_texts[stat.name].total:set_color(colour)

    else self._player_stats_texts[stat.name].total:set_color(tweak_data.screen_colors.text) end
  end
end)

Hooks:OverrideFunction(PlayerInventoryGui, "_get_armor_stats", function(self, name)
  local base_stats, mods_stats, skill_stats = {}, {}, {}
  local detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data({ armors = name}, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
  detection_risk = math.round(detection_risk * 100)
  local bm_armor_tweak = tweak_data.blackmarket.armors[name]
  local upgrade_level = bm_armor_tweak.upgrade_level
  local PresentMult = tweak_data.gui.stats_present_multiplier -- Converts values to be more presentable

  for i, stat in ipairs(self._player_stats_shown) do
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
			local base = tweak_data.player.movement_state.standard.movement.speed.STANDARD_MAX / 100 * PresentMult
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
			base_stats[stat.name] = { value = (base_value + mod_value) * PresentMult }
			skill_stats[stat.name] = { value = skill_value * PresentMult }

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