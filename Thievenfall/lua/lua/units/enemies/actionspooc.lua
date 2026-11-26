-- Build CloakerEffect mutator directly into cloakers
local function CloakerEffectSmoke(unit)
  local mov_ext = unit:movement()
  local tracker = mov_ext and mov_ext:nav_tracker()
  local pos = tracker and tracker:field_position() or unit:position()
  local ray_to = mvector3.copy(pos)

  mvector3.set_z(ray_to, ray_to.z - 50)

  local ground_ray = unit:raycast("ray", pos, ray_to, "slot_mask", managers.slot:get_mask("statics"))

  if ground_ray then
    mvector3.set(pos, ground_ray.hit_position)
    mvector3.set_z(pos, pos.z + 3)
  end

  local duration = tweak_data.group_ai.smoke_grenade_lifetime
  managers.groupai:state():spawn_instant_local_smoke_grenade(pos, duration)
end

local CloakerFire = {
  alert_radius = 1500,
  burn_duration = 15,
  burn_tick_period = 0.5,
  curve_pow = 3,
  damage = 1,
  dot_data_name = "enemy_mutator_cloaker_groundfire",
  effect_name = "effects/payday2/particles/explosions/molotov_grenade",
  fire_alert_radius = 1500,
  hexes = 6,
  player_damage = 2,
  range = 75,
  sound_event = "molotov_impact",
  sound_event_burning = "burn_loop_gen",
  sound_event_impact_duration = 4
}

local function CloakerEffectFire(unit)
  local mov_ext = unit:movement()
  local tracker = mov_ext and mov_ext:nav_tracker()
  local pos = tracker and tracker:field_position() or unit:position()
  local ray_to = mvector3.copy(pos)

  mvector3.set_z(ray_to, ray_to.z - 50)

  local ground_ray = unit:raycast("ray", pos, ray_to, "slot_mask", managers.slot:get_mask("statics"))
  if ground_ray then
    mvector3.set(pos, ground_ray.hit_position)
    mvector3.set_z(pos, pos.z + 3)
  end

  EnvironmentFire.spawn(pos, unit:rotation(), CloakerFire, math.UP, unit, nil, 0, 1)
end

local function CloakerEffectExplode(unit)
  local foot = unit:get_object(Idstring("RightFoot"))
  local pos = foot and foot:position() or unit:position()
  local range = 500
  local ply_damage = 40
  local normal = math.UP
  local effect_params = {
    camera_shake_max_mul = 4,
    effect = "effects/payday2/particles/explosions/grenade_explosion",
    sound_event = "grenade_explode",
    sound_muffle_effect = true,
    feedback_range = range * 2
  }

  managers.explosion:give_local_player_dmg(pos, range, ply_damage)
  managers.explosion:play_sound_and_effects(pos, normal, range, effect_params)

  if Network:is_server() then
    local damage = 150
    local curve_pow = 3
    local damage_params = {
      no_raycast_check_characters = true,
      player_damage = 0,
      hit_pos = pos, range = range,
      collision_slotmask = managers.slot:get_mask("explosion_targets"),
      curve_pow = curve_pow, damage = damage,
      user = unit
      -- Cloaker can kill himself. Kaboom!
    }

    managers.explosion:detect_and_give_dmg(damage_params)
    managers.network:session():send_to_peers_synched("element_explode_on_client", pos, normal, damage, range, curve_pow)
  end
end

local CloakerEffects = {
  CloakerEffectSmoke, CloakerEffectSmoke, -- Very Hard & OVERKILL
  CloakerEffectSmoke, CloakerEffectFire, -- Mayhem & Death Wish
  CloakerEffectFire, CloakerEffectExplode -- Death Sentence
}
--[[
Each difficulty up includes the effects below it, effectively this results in the following odds:
Very Hard & OVERKILL: 100% smoke
Mayhem & Death Wish: 75% smoke, 25% fire
Death Sentence: 50% smoke, 33% fire, 17% explosion
]]

local function RandomCloakerEffect(unit)
  local options = math.floor((tweak_data:difficulty_to_index(Global.game_settings.difficulty) - 2) * 0.5)

  if options == 0 then return
  else options = options * 2 end

  local random = math.clamp(unit:id() % options + 1, 1, options)
  CloakerEffects[random](unit)
end

-- Replace mutator calls with RandomCloakerEffect
Hooks:OverrideFunction(ActionSpooc, "anim_act_clbk", function(self, anim_act)
  if anim_act == "strike" then
    local sound_string = "clk_punch_3rd_person_3p"

    if self._stroke_t then
      if self._strike_unit then self._unit:sound():say(sound_string, true, true) end
    return end

    self._stroke_t = TimerManager:game():time()
    self._unit:sound():play(self:get_sound_event("detect_stop"))

    if not self._is_local then
      self._unit:sound():say(sound_string, true, true)
      self._beating_end_t = self._stroke_t + 1
      RandomCloakerEffect(self._unit)
    return end

    if self:_chk_target_invalid() then
      if Network:is_server() then self:_expire()
      else self:_wait() end
    return end

    local target_vec = self._tmp_vec1

    mvector3.set(target_vec, self._target_unit:movement():m_com())
    mvector3.subtract(target_vec, self._common_data.pos)

    local target_dis_z = math.abs(mvector3.z(target_vec))

    if target_dis_z > 200 then
      if not self:is_flying_strike() then
        if Network:is_server() then self:_expire()
        else self:_wait() end
      end
    return end

    mvector3.set_z(target_vec, 0)

    if self:is_flying_strike() then
      local angle = mvector3.angle(target_vec, self._common_data.fwd)
      local max_dis = math.lerp(170, 70, math.clamp(angle, 0, 90) / 90)
      local target_dis_xy = mvector3.normalize(target_vec)

      if max_dis < target_dis_xy then
        if not self:is_flying_strike() then
          if Network:is_server() then self:_expire()
          else self:_wait() end
        end
      return end
    end

    self._strike_unit = self._target_unit
    local spooc_res = self._strike_unit:movement():on_SPOOCed(self._unit, self:is_flying_strike() and "flying_strike" or "sprint_attack")
    RandomCloakerEffect(self._unit)

    if spooc_res == "countered" then
      if not Network:is_server() then self._ext_network:send_to_host("action_spooc_stop", self._ext_movement:m_pos(), 1, self._action_id) end

      self._blocks = {}
      local action_data = {
        damage = 0,
        damage_effect = 1,
        variant = "counter_spooc",
        attacker_unit = self._strike_unit,
        col_ray = { body = self._unit:body("body"), position = self._common_data.pos + math.UP * 100 },
        attack_dir = -1 * target_vec:normalized(),
        name_id = managers.blackmarket:equipped_melee_weapon()
      }
      self._unit:character_damage():damage_melee(action_data)
      return

    elseif not self:is_flying_strike() then
      if spooc_res and self._strike_unit:character_damage():is_downed() then
        self._beating_end_t = self._stroke_t + math.lerp(self._common_data.char_tweak.spooc_attack_beating_time[1], self._common_data.char_tweak.spooc_attack_beating_time[2], math.random())
      elseif Network:is_server() then -- Nothing
      else self._ext_network:send_to_host("action_spooc_stop", self._ext_movement:m_pos(), 1, self._action_id) end
    return end

    self._unit:sound():say(sound_string, true, true)

    if self._strike_unit:base().is_local_player then
      self:_play_strike_camera_shake()
      mvector3.negate(target_vec)
      managers.hud:on_hit_direction(target_vec, HUDHitDirection.DAMAGE_TYPES.HEALTH, 0)
    end

    if not self:is_flying_strike() then
      mvector3.set(self._last_sent_pos, self._common_data.pos)
      self._ext_network:send("action_spooc_strike", mvector3.copy(self._common_data.pos), self._action_id)
      self._nav_path[self._nav_index + 1] = mvector3.copy(self._common_data.pos)
    end
  end
end)