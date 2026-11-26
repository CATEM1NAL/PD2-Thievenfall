Hooks:PreHook(IncendiaryBurstGrenade, "_detonate", "CrimDusk_PreDetonateIncendiaryGrenade", function(self)
  if not self._airdrop_unit or self._detonated then return end
  self._detonated = true

  local pos = self._unit:position()
  managers.explosion:play_sound_and_effects(pos, math.UP, self._range, self._custom_params)

  local hit_units, splinters = managers.explosion:detect_and_stun({
    player_damage = 0,
    hit_pos = self._unit:position(),
    range = self._range,
    collision_slotmask = managers.slot:get_mask("explosion_targets"),
    curve_pow = self._curve_pow,
    damage = self._damage,
    ignore_unit = self._unit,
    alert_radius = self._alert_radius,
    user = self:thrower_unit() or self._unit,
    owner = self._unit,
    verify_callback = callback(self, self, "_can_stun_unit")
  })

  if self._unit:id() ~= -1 and managers.network:session() then
    managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
  end

  self:_handle_hiding_and_destroying(true, self:_destruct_delay())
  self:_check_stop_flyby_sound()

  if not Network:is_server() then return end

  managers.game_play_central:server_spawn_pubg_cargos(self._airdrop_unit, self._unit:position(), (self:thrower_unit() or self._unit):position())
end)

function IncendiaryBurstGrenade:_can_stun_unit(unit)
  local unit_name
  if unit and unit:base() then unit_name = unit:base()._tweak_table end

  if alive(unit) and unit:brain() then
    local brain = unit:brain()
    if brain.is_hostage and brain:is_hostage() or brain.is_current_logic and brain:is_current_logic("trade") then
      return false
    end
  end

  if unit_name then managers.game_play_central:auto_highlight_enemy(unit, true) return not (tweak_data.character[unit_name] or {}).immune_to_concussion
  else managers.game_play_central:auto_highlight_enemy(unit, true) return true end
end