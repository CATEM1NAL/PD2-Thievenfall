Hooks:OverrideFunction(ProjectileBase, "create_sweep_data", function(self)
  self._sweep_data = {}
  self._sweep_data.slot_mask = self._slot_mask + 3
  self._sweep_data.current_pos = self._unit:position()
  self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end)