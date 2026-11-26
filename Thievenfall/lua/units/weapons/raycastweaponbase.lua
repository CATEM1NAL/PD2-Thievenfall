local FileIdent = "RaycastWeaponBase"

-- Finds the magazine containing the most ammo for the equipped weapon
local function ReturnBiggestMag(self, current_mag)
  current_mag = current_mag or 0

  local BiggestMag, MagNum = current_mag, 0
  for mag, ammo in ipairs(self._magazines) do
    if ammo > BiggestMag then
      BiggestMag = ammo
      MagNum = mag
    end
  end

  return BiggestMag, MagNum
end

-- Finds the magazine containing the least ammo for the equipped weapon
local function ReturnSmallestMag(self)
  local SmallestMag, MagNum = 0, 0
  for mag, ammo in ipairs(self._magazines) do
    if ammo < SmallestMag or MagNum == 0 then
      SmallestMag = ammo
      MagNum = mag
    end
  end

  return SmallestMag, MagNum
end

-- Updates ammo count for specified magazine
local function SetMagazineAmmo(self, mag, new_ammo)
  self._magazines = self._magazines or {}

  local _
  if not mag or mag < 1 then _, mag = ReturnBiggestMag(self) end
  if mag < 1 then return end

  if new_ammo then self._magazines[mag] = math.max(new_ammo, 0)
  else self._magazines[mag] = nil end -- Allows deleting magazines if needed

  CrimDusk.Log(FileIdent, "Reserve mag " .. mag .. " now has " .. self._magazines[mag] .. " bullets", true)
end

Hooks:OverrideFunction(NewRaycastWeaponBase, "replenish", function(self)
  local ammo_max_multiplier = managers.player:upgrade_value("player", "extra_ammo_multiplier", 1)

  for _, category in ipairs(self:categories()) do
    ammo_max_multiplier = ammo_max_multiplier * managers.player:upgrade_value(category, "extra_ammo_multiplier", 1)
  end

  ammo_max_multiplier = ammo_max_multiplier + ammo_max_multiplier * (self._total_ammo_mod or 0)

  if managers.player:has_category_upgrade("player", "add_armor_stat_skill_ammo_mul") then
    ammo_max_multiplier = ammo_max_multiplier * managers.player:body_armor_value("skill_ammo_mul", nil, 1)
  end

  ammo_max_multiplier = managers.modifiers:modify_value("WeaponBase:GetMaxAmmoMultiplier", ammo_max_multiplier)

  local ammo_max_per_clip = self:calculate_ammo_max_per_clip()
  --local ammo_max = math.round((tweak_data.weapon[self._name_id].AMMO_MAX + managers.player:upgrade_value(self._name_id, "clip_amount_increase") * ammo_max_per_clip) * ammo_max_multiplier)
  local reserve_magazines = (tweak_data.weapon[self._name_id].NR_CLIPS_MAX - 1) + managers.player:upgrade_value("weapon", "extra_magazines", 0)
  local ammo_max = reserve_magazines * ammo_max_per_clip

  --ammo_max_per_clip = math.min(ammo_max_per_clip, ammo_max)

  self:set_ammo_max_per_clip(ammo_max_per_clip)
  self:set_ammo_max(ammo_max)
  self:set_ammo_total(ammo_max)
  self:set_ammo_remaining_in_clip(ammo_max_per_clip)

  -- Fill all mags
  for i = 1, reserve_magazines do SetMagazineAmmo(self, i, ammo_max_per_clip) end

  self._ammo_pickup = tweak_data.weapon[self._name_id].AMMO_PICKUP

  if self._assembly_complete then
    for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
      if gadget and gadget.replenish then
        gadget:replenish()
      end
    end
  end

  self:update_damage()
end)

-- Calculate ammo for reload
Hooks:OverrideFunction(RaycastWeaponBase, "get_ammo_max_per_clip", function(self)
  if self._name_id:sub(-4) == "_npc" or self._name_id:sub(-5) == "_crew" or not self._magazines then return self._ammo_max_per_clip end

  local ammo_base = self._reload_ammo_base or self:ammo_base()
  local ammo_remaining = ammo_base:get_ammo_remaining_in_clip()

  local chamber = math.min(self:weapon_tweak_data().ChamberRounds or 1, ammo_remaining)
  if self:use_shotgun_reload() then return self._ammo_max_per_clip + chamber end

  local BiggestMag, MagNumber = ReturnBiggestMag(self, ammo_remaining)
  local BiggestReserve = ReturnBiggestMag(self)

  if chamber == 0 or BiggestMag > BiggestReserve then return BiggestMag end
  return math.min(BiggestMag, self._ammo_max_per_clip) + chamber, MagNumber
end)

Hooks:OverrideFunction(RaycastWeaponBase, "set_ammo_total", function(self, ammo_total)
  if self._name_id:sub(-4) == "_npc" or self._name_id:sub(-5) == "_crew" or not self._magazines then self._ammo_total = ammo_total return end
  local ammo_base = self._reload_ammo_base or self:ammo_base()

  ammo_total = ammo_base:get_ammo_remaining_in_clip()
  --CrimDusk.Log(FileIdent, "Loaded in gun: " .. ammo_total, true)

  for mag, ammo in ipairs(self._magazines) do
    --CrimDusk.Log(FileIdent, "Reserve mag " .. mag .. ": " .. ammo, true)
    ammo_total = ammo_total + ammo
  end

  self._ammo_total = ammo_total

  if self:has_stored_pickup_ammo() and ammo_total >= self:get_ammo_max() then self:remove_pickup_ammo() end
end)

Hooks:OverrideFunction(RaycastWeaponBase, "on_reload", function(self)
  local ammo_base = self._reload_ammo_base or self:ammo_base()
  local amount, next_mag = ammo_base:get_ammo_max_per_clip()
  local CurrentMag = ammo_base:get_ammo_remaining_in_clip()

  local WeaponTweak = self:weapon_tweak_data()
  local chamber = WeaponTweak.ChamberRounds or 1
  local InMag = CurrentMag - chamber

  if WeaponTweak.MagDump then InMag = 0 end

  SetMagazineAmmo(self, next_mag, InMag)

  ammo_base:set_ammo_remaining_in_clip(amount)
  ammo_base:set_ammo_total(amount)

  managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

  self._reload_ammo_base = nil
  self._next_fire_allowed = self._unit:timer():time()
end)

-- Shotgun reload
Hooks:OverrideFunction(NewRaycastWeaponBase, "update_reloading", function(self, t, dt, time_left)
  if self._use_shotgun_reload and self._next_shell_reloded_t and t > self._next_shell_reloded_t then
    local speed_multiplier = self:reload_speed_multiplier()
    local shotgun_reload_tweak = self:_get_shotgun_reload_tweak_data(not self._started_reload_empty)
    local ammo_to_reload = 1
    local next_queue_data

    if shotgun_reload_tweak and shotgun_reload_tweak.reload_queue then
      self._shotgun_queue_index = self._shotgun_queue_index % #shotgun_reload_tweak.reload_queue + 1

      if self._shotgun_queue_index == #shotgun_reload_tweak.reload_queue then
        self._next_shell_reloded_t = self._next_shell_reloded_t + (shotgun_reload_tweak.reload_queue_wrap or 0)
      end

      local queue_data = shotgun_reload_tweak.reload_queue[self._shotgun_queue_index]

      ammo_to_reload = queue_data and queue_data.reload_num or 1
      next_queue_data = shotgun_reload_tweak.reload_queue[self._shotgun_queue_index + 1]
      self._next_shell_reloded_t = self._next_shell_reloded_t + (next_queue_data and next_queue_data.expire_t or 0.5666666666666667) / speed_multiplier

    else
      self._next_shell_reloded_t = self._next_shell_reloded_t + self:reload_shell_expire_t(not self._started_reload_empty) / speed_multiplier
      ammo_to_reload = shotgun_reload_tweak and shotgun_reload_tweak.reload_num or 1
    end

    local reserve_ammo, next_mag = ReturnBiggestMag(self)
    self:set_ammo_remaining_in_clip(math.min(self:get_ammo_total(), self:get_ammo_max_per_clip(), self:get_ammo_remaining_in_clip() + ammo_to_reload))
    SetMagazineAmmo(self, next_mag, reserve_ammo - ammo_to_reload)
    self:set_ammo_total()
    log("RELOADING " .. reserve_ammo - ammo_to_reload)

    managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

    if not next_queue_data or not next_queue_data.skip_update_ammo then self:update_ammo_objects() end

    return true
  end
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

-- Pickup ammo
Hooks:OverrideFunction(RaycastWeaponBase, "add_ammo", function(self, ratio, add_amount_override)
  local mul_1 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier", 1) - 1
  local mul_2 = managers.player:upgrade_value("player", "pick_up_ammo_multiplier_2", 1) - 1
  local crew_mul = managers.player:crew_ability_upgrade_value("crew_scavenge", 0)
  local pickup_mul = 1 + mul_1 + mul_2 + crew_mul

  local function _add_ammo(ammo_base, ratio, add_amount_override)
    if ammo_base:get_ammo_max() <= ammo_base:get_ammo_total() - ammo_base:get_ammo_remaining_in_clip() then return false, 0 end

    local picked_up = true
    --local stored_pickup_ammo
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
      --[[stored_pickup_ammo = ammo_base:get_stored_pickup_ammo()

      if stored_pickup_ammo then
        add_amount = add_amount + stored_pickup_ammo
        ammo_base:remove_pickup_ammo()
      end]]
    end

    local SmallestMag, MagNum = ReturnSmallestMag(self)
    local rounded_amount = math.floor(add_amount)
    local new_ammo = SmallestMag + rounded_amount
    add_amount = 0

    -- Refill current smallest mag until all ammo is used up or all mags are full
    while new_ammo > SmallestMag and SmallestMag ~= self._ammo_max_per_clip do
      add_amount = add_amount + (new_ammo - SmallestMag)
      SetMagazineAmmo(self, MagNum, math.min(new_ammo, self._ammo_max_per_clip))
      if new_ammo - self._ammo_max_per_clip <= 0 then break end

      SmallestMag, MagNum = ReturnSmallestMag(self)
      new_ammo = SmallestMag + math.max(new_ammo - self._ammo_max_per_clip, 0)
    end

    local max_allowed_ammo = ammo_base:get_ammo_max()
    ammo_base:set_ammo_total(math.clamp(new_ammo, 0, max_allowed_ammo))

    --[[
    local new_ammo = ammo_base:get_ammo_total() + rounded_amount
    local max_allowed_ammo = ammo_base:get_ammo_max()

    if not add_amount_override and new_ammo < max_allowed_ammo then
      local leftover_ammo = add_amount - rounded_amount
      if leftover_ammo > 0 then ammo_base:store_pickup_ammo(leftover_ammo) end
    end

    ammo_base:set_ammo_total(math.clamp(new_ammo, 0, max_allowed_ammo))

    if stored_pickup_ammo then add_amount = math.floor(add_amount - stored_pickup_ammo)
    else add_amount = rounded_amount end
    ]]

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

-- Ammo bags
Hooks:OverrideFunction(RaycastWeaponBase, "add_ammo_from_bag", function(self, available)
  local function process_ammo(ammo_base, amount_available)
    if not amount_available then return 0 end

    local ammo_max = ammo_base:get_ammo_max()
    local ammo_total = ammo_base:get_ammo_total() - ammo_base:get_ammo_remaining_in_clip()
    if ammo_max <= ammo_total then return 0 end

    log(ammo_total .. "/" .. ammo_max)

    local mag_size = ammo_base._ammo_max_per_clip
    --local cost_mult = ammo_base:weapon_tweak_data().use_data.selection_index

    --local wanted = 1 - (0.25 * (ammo_total / mag_size) * cost_mult)
    local wanted = 1 - (ammo_total / ammo_max)
    local can_have = math.min(wanted, amount_available)

    for mag, ammo in ipairs(self._magazines) do
      local NewAmmo = math.min(ammo + math.ceil(mag_size * can_have), mag_size)
      self._magazines[mag] = NewAmmo
    end

    ammo_base:set_ammo_total()
    return can_have
  end

  local can_have = process_ammo(self, available)

  available = available - can_have

  for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
    if gadget and gadget.ammo_base then
      local ammo = process_ammo(gadget:ammo_base(), available)

      can_have = can_have + ammo
      available = available - ammo

      gadget:on_add_ammo_from_bag()
    end
  end

  return can_have
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