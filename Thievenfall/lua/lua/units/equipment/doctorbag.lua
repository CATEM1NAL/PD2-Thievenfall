Hooks:PostHook(DoctorBagBase, "init", "CrimDusk_InitDoctorBag", function(self)
  self._max_amount = 4
end)

Hooks:OverrideFunction(DoctorBagBase, "setup", function(self, bits)
  local amount_upgrade_lvl, dmg_reduction_lvl = 3, 1
  if bits ~= 255 then amount_upgrade_lvl, dmg_reduction_lvl = self:_get_upgrade_levels(bits) end

  local doctor_bag_amount_increase = managers.player:upgrade_value_by_level("doctor_bag", "amount_increase", amount_upgrade_lvl)
  self._amount = tweak_data.upgrades.doctor_bag_base + doctor_bag_amount_increase
  self._damage_reduction_upgrade = dmg_reduction_lvl ~= 0

  self:_set_visual_stage()

  if Network:is_server() and self._is_attachable then
    local from_pos = self._unit:position() + self._unit:rotation():z() * 10
    local to_pos = self._unit:position() + self._unit:rotation():z() * -10
    local ray = self._unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))

    if ray then
      self._attached_data = {}
      self._attached_data.body = ray.body
      self._attached_data.position = ray.body:position()
      self._attached_data.rotation = ray.body:rotation()
      self._attached_data.index = 1
      self._attached_data.max_index = 3

      self._unit:set_extension_update_enabled(Idstring("base"), true)
    end
  end
end)