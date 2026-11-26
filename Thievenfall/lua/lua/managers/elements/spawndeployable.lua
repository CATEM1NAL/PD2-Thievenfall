Hooks:OverrideFunction(ElementSpawnDeployable, "on_executed", function(self, instigator)
  if not self._values.enabled then return end

  if self._values.deployable_id ~= "none" then
    if self._values.deployable_id == "doctor_bag" then DoctorBagBase.spawn(self._values.position, self._values.rotation, 255)
    elseif self._values.deployable_id == "ammo_bag" then AmmoBagBase.spawn(self._values.position, self._values.rotation, 3, nil, 1)
    elseif self._values.deployable_id == "bodybags_bag" then BodyBagsBagBase.spawn(self._values.position, self._values.rotation, 0) end
  end

  ElementSpawnDeployable.super.on_executed(self, instigator)
end)