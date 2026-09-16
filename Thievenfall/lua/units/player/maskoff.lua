Hooks:OverrideFunction(PlayerMaskOff, "_check_action_run", function() return end)

Hooks:PostHook(PlayerMaskOff, "_enter", "CrimDusk_EnterMaskOffState", function(self)
  self._unit:mover():set_gravity(Vector3(0, 0, -1800))
end)

-- Allow interactions
Hooks:OverrideFunction(PlayerMaskOff, "_check_action_interact", function(self, t, input)
  local pressed, released, holding
  if self._interact_expire_t and not self._start_standard_expire_t then pressed, released, holding = self:_check_tap_to_interact_inputs(t, input.btn_interact_press, input.btn_interact_release, input.btn_interact_state)
  else pressed, released, holding = input.btn_interact_press, input.btn_interact_release, input.btn_interact_state end

  local new_action, timer, interact_object
  if pressed then
    if _G.IS_VR then self._interact_hand = input.btn_interact_left_press and PlayerHand.LEFT or PlayerHand.RIGHT end

    local action_forbidden = self:chk_action_forbidden("interact") or self._unit:base():stats_screen_visible() or self:_interacting() or self._ext_movement:has_carry_restriction() or self:is_deploying() or self:_on_zipline()
    if not action_forbidden then
      new_action, timer, interact_object = managers.interaction:interact(self._unit, input.data, self._interact_hand)

      if timer then
        new_action = true

        self._ext_camera:camera_unit():base():set_limits(80, 50)
        self:_start_action_interact(t, input, timer, interact_object)
        self:_chk_tap_to_interact_enable(t, timer, interact_object)
      end

      if not new_action and (not self._intimidate_t or t - self._intimidate_t > tweak_data.player.movement_state.interaction_delay) then
        self._intimidate_t = t
        new_action = self:mark_units("f11", t, true)
      end
    end
  end

  if released then self:_interupt_action_interact() end
  return new_action
end)

-- Interacting increases detection
Hooks:PostHook(PlayerMaskOff, "_start_action_interact", "CrimDusk_StartMaskOffInteract", function(self)
  self._unit:base():set_suspicion_multiplier("interacting", 5)
  self._unit:base():set_detection_multiplier("interacting", 5)
end)

Hooks:PostHook(PlayerMaskOff, "_interupt_action_interact", "CrimDusk_EndMaskOffInteract", function(self)
  self._unit:base():set_suspicion_multiplier("interacting", 1)
  self._unit:base():set_detection_multiplier("interacting", 1)
end)

Hooks:PostHook(PlayerMaskOff, "exit", "CrimDusk_ForceLoudMaskup", function()
  if NetworkHelper:IsHost() then CrimDusk.GoLoud() return end
  NetworkHelper:SendToPeer(1, "CrimDusk_MaskedUp", true)
  Hooks:RemovePostHook("CrimDusk_ForceLoudMaskup")
end)