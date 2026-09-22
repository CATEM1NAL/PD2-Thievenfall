Hooks:OverrideFunction(PlayerTased, "give_shock_to_taser_no_damage", function(self)
  local taser_unit = self._taser_unit
  local char_dmg_ext = alive(taser_unit) and taser_unit:character_damage()
  if not char_dmg_ext or not char_dmg_ext.force_hurt then return end

  self._countering_tase = true

  local pos = mvector3.copy(taser_unit:movement():m_head_pos())
  local damage_info = {
    damage = 0,
    variant = "counter_tased", pos = pos,
    attack_dir = -taser_unit:movement()._action_common_data.fwd,
    col_ray = { unit = taser_unit, position = pos },
    result = { type = "counter_tased", variant = "counter_tased" },
    attacker_unit = self._unit
  }

  char_dmg_ext:damage_tase(damage_info)

  local sound_ext = taser_unit:sound()
  if sound_ext then sound_ext:play("tase_counter_attack", nil, true) end
  self._ext_camera:play_redirect(self:get_animation("tased_counter"))
end)