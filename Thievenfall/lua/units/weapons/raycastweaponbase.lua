local FileIdent = "RaycastWeaponBase"

-- One in chamber
Hooks:OverrideFunction(RaycastWeaponBase, "get_ammo_max_per_clip", function(self)
  local chamber = self:weapon_tweak_data().ChamberRounds or 1
  if self:clip_empty() or chamber == 0 then return self._ammo_max_per_clip end
  return self._ammo_max_per_clip + chamber
end)

Hooks:OverrideFunction(RaycastWeaponBase, "on_reload", function(self)
  local ammo_base = self._reload_ammo_base or self:ammo_base()
  local amount = ammo_base:get_ammo_max_per_clip()
  local CurrentMag = ammo_base:get_ammo_remaining_in_clip()

  local WeaponTweak = self:weapon_tweak_data()
  local chamber = WeaponTweak.ChamberRounds or 1
  local MagDump = CurrentMag - chamber

  if CurrentMag > 0 and CurrentMag < chamber then amount = amount + MagDump end

  -- Ammo not used is wasted
  if WeaponTweak.MagDump and CurrentMag > chamber then
    ammo_base:set_ammo_total(ammo_base._ammo_total - MagDump)
    CrimDusk.Log(FileIdent, "Dumping " .. MagDump .. " rounds", true)
  end

  if self._setup.expend_ammo then ammo_base:set_ammo_remaining_in_clip(math.min(ammo_base:get_ammo_total(), amount))
  else
    ammo_base:set_ammo_remaining_in_clip(amount)
    ammo_base:set_ammo_total(amount)
  end

  managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

  self._reload_ammo_base = nil
  self._next_fire_allowed = self._unit:timer():time()
end)

-- Enable friendly fire by default
Hooks:OverrideFunction(InstantBulletBase, "bullet_slotmask", function(self)
  return managers.slot:get_mask("bullet_impact_targets") + 3
end)

Hooks:OverrideFunction(RaycastWeaponBase, "_get_current_damage", function(self, dmg_mul)
  local damage = self._damage * (dmg_mul or 1)
  damage = damage * managers.player:temporary_upgrade_value("temporary", "combat_medic_damage_multiplier", 1)

  if self:clip_empty() then -- Finisher
    local FinisherMult = managers.player:upgrade_value("weapon", "coup_de_grace_mult", 1)
    damage = damage * FinisherMult
  end

  return damage
end)

Hooks:OverrideFunction(RaycastWeaponBase, "add_ammo", function(self, ratio, add_amount_override)
  local mul_1 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier", 1) - 1
  local mul_2 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier_2", 1) - 1
  local crew_mul = managers.player:crew_ability_upgrade_value("crew_scavenge", 0)
  local pickup_mul = 1 + mul_1 + mul_2 + crew_mul

  local function _add_ammo(ammo_base, ratio, add_amount_override)
    if ammo_base:get_ammo_max() == ammo_base:get_ammo_total() then return false, 0 end

    local picked_up = true
    local stored_pickup_ammo
    local add_amount = add_amount_override

    if not add_amount then
      local min_pickup = ammo_base._ammo_pickup[1]
      local max_pickup = ammo_base._ammo_pickup[2]

      if ammo_base._ammo_data and (ammo_base._ammo_data.ammo_pickup_min_mul or ammo_base._ammo_data.ammo_pickup_max_mul) then
        min_pickup = min_pickup * (ammo_base._ammo_data.ammo_pickup_min_mul or 1)
        max_pickup = max_pickup * (ammo_base._ammo_data.ammo_pickup_max_mul or 1)
      end

      add_amount = math.lerp(min_pickup * pickup_mul, max_pickup * pickup_mul, math.random())
      picked_up = add_amount > 0
      add_amount = add_amount * (ratio or 1)
      stored_pickup_ammo = ammo_base:get_stored_pickup_ammo()

      if stored_pickup_ammo then
        add_amount = add_amount + stored_pickup_ammo
        ammo_base:remove_pickup_ammo()
      end
    end

    local rounded_amount = math.floor(add_amount)
    local new_ammo = ammo_base:get_ammo_total() + rounded_amount
    local max_allowed_ammo = ammo_base:get_ammo_max()

    if not add_amount_override and new_ammo < max_allowed_ammo then
      local leftover_ammo = add_amount - rounded_amount

      if leftover_ammo > 0 then ammo_base:store_pickup_ammo(leftover_ammo) end
    end

    ammo_base:set_ammo_total(math.clamp(new_ammo, 0, max_allowed_ammo))

    if stored_pickup_ammo then add_amount = math.floor(add_amount - stored_pickup_ammo)
    else add_amount = rounded_amount end

    -- Scrounger
    local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
    local may_find_grenade = grenade_tweak.is_a_grenade and managers.player:has_category_upgrade("player", "regain_throwable_from_ammo")

    if may_find_grenade then
      local scrounger = managers.player:upgrade_value("player", "regain_throwable_from_ammo", nil)
      if scrounger and not managers.player:got_max_grenades() then managers.player:speed_up_grenade_cooldown(scrounger) end
    end

    return picked_up, add_amount
  end

  local picked_up, add_amount

  picked_up, add_amount = _add_ammo(self, ratio, add_amount_override)

  if self.AKIMBO then
    local akimbo_rounding = self:get_ammo_total() % 2 + #self._fire_callbacks
    if akimbo_rounding > 0 then _add_ammo(self, nil, akimbo_rounding) end
  end

  for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
    if gadget and gadget.ammo_base then
      local p, a = _add_ammo(gadget:ammo_base(), ratio, add_amount_override)
      picked_up = p or picked_up
      add_amount = add_amount + a

      if self.AKIMBO then
        local akimbo_rounding = gadget:ammo_base():get_ammo_total() % 2 + #self._fire_callbacks
        if akimbo_rounding > 0 then _add_ammo(gadget:ammo_base(), nil, akimbo_rounding) end
      end
    end
  end

  return picked_up, add_amount
end)

--[[
-- uncomment to see spread values, used for testing
Hooks:PostHook(NewRaycastWeaponBase, "_get_spread", "CrimDusk_NewRaycastGetSpread", function(self)
  local spread_x, spread_y = Hooks:GetReturn()
  CrimDusk.Log(FileIdent, "Spread: " .. spread_x .. " " .. spread_y)
end)
]]

-- Mag Plus
Hooks:OverrideFunction(NewRaycastWeaponBase, "calculate_ammo_max_per_clip", function(self)
  local ammo = tweak_data.weapon[self._name_id].CLIP_AMMO_MAX
  ammo = ammo + (self._extra_ammo or 0)
  ammo = ammo * (1 + managers.player:upgrade_value("weapon", "clip_ammo_increase", 0))
  return math.floor(ammo)
end)

-- Body Expertise
Hooks:OverrideFunction(NewRaycastWeaponBase, "get_add_head_shot_mul", function(self)
  return managers.player:upgrade_value("weapon", "automatic_head_shot_add", nil)
end)