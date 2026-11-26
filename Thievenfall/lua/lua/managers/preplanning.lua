Hooks:OverrideFunction(PrePlanningManager, "_check_spawn_deployable", function(self, type, element)
  local type_data = tweak_data.preplanning.types[type]
  local deployable_id = type_data.deployable_id
  if not deployable_id then return end

  local pos, rot = element:get_orientation()
  if deployable_id == "doctor_bag" then DoctorBagBase.spawn(pos, rot, 255)
  elseif deployable_id == "ammo_bag" then AmmoBagBase.spawn(pos, rot, 3, nil, 1)
  elseif deployable_id == "bodybags_bag" then BodyBagsBagBase.spawn(pos, rot, 0) end
end)