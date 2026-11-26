local tmp_rot1 = Rotation()

local function LocalCamRotation(self, yaw)
  local yaw_obj = self._yaw_obj or self._unit:get_object(Idstring("CameraYaw"))
  local original_yaw_rot = yaw_obj:local_rotation()
  local new_yaw_rot = Rotation(180 + yaw, original_yaw_rot:pitch(), original_yaw_rot:roll())
  yaw_obj:set_local_rotation(new_yaw_rot)

  self._look_fwd = nil
  self._unit:set_moving()

  self._yaw = yaw
  if not self._queue_send_rot then self._queue_send_rot = true end
end

Hooks:PostHook(SecurityCamera, "set_detection_enabled", "CrimDusk_SetInitialCamYaw", function(self, state, settings)
  if settings then
    self:apply_rotations(0, settings.pitch) -- force cam to face forwards so rotation applies correctly
    self._max_rot_yaw = 50 -- how many degrees l/r cam can rotate
    self._rotate_speed = (math.random(0, 1) * 2 - 1) * math.random() * self._max_rot_yaw
    --[[ rotation speed is a random float between -1 to 1, multiplied by max rotate distance.
    rotation for host updates every frame so it's *buttery smooth* and uses dt for fps independence.
    because rotation uses dt, rotate speed is effectively how many degrees the cam rotates per second.
    current settings mean at max speed it can complete a rotation in one second, on avg it'll take two. ]]

    self._last_rotate_t = self._last_rotate_t or TimerManager:game():time()
  end
end)

Hooks:OverrideFunction(SecurityCamera, "_upd_detection", function(self, t)
  -- Cam rotation
  if NetworkHelper:IsHost() and t > self._last_rotate_t then
    local dt = t - self._last_rotate_t
    local NewYaw = self._yaw + (self._rotate_speed * dt)
    if NewYaw >= self._max_rot_yaw or NewYaw <= -self._max_rot_yaw then
      self._rotate_speed = -self._rotate_speed
      self._last_rotate_t = t + 5

    else self._last_rotate_t = t
      LocalCamRotation(self, NewYaw)
    end
  end

  -- Detection
  local dt = t - self._last_detect_t
  if dt > self._detection_interval then
    self._last_detect_t = t

    --[[ Enable debug camera radius
    -- ORIGINAL INTENT WAS TO USE FOR CAMERA VISUALISATION LIKE PAYDAY 3
    -- SHOULDN'T BE USED, CONES CLIP THROUGH WALLS AND LOOK ASS
    local ConeColour = next(self._detected_attention_objects) and Color(0.05, 1, 0, 0) or Color(0.05, 0, 1, 0)
    self._brush = self._brush or Draw:brush(ConeColour, self._detection_interval)
    self._look_obj:m_position(self._tmp_vec1)
    local cone_base = self._look_obj:rotation():y()
    mvector3.multiply(cone_base, self._range)
    mvector3.add(cone_base, self._tmp_vec1)
    local cone_base_rad = math.tan(self._cone_angle * 0.5) * self._range
    self._brush:cone(self._tmp_vec1, cone_base, cone_base_rad, 16)
    ]]

    if not self._look_fwd then
      self._look_obj:m_rotation(tmp_rot1)
      self._look_fwd = Vector3()
      mrotation.y(tmp_rot1, self._look_fwd)
    end

    -- Send rotation on detection ticks to avoid network spam
    -- Ideally camrot speed should be synced with clients so we don't need to send this at all
    if self._queue_send_rot then
      
      managers.network:session():send_to_peers_synched("camera_yaw_pitch", self._unit, 255 * (self._yaw + 180) / 360, 255 * (self._pitch + 90) / 180)
      self._queue_send_rot = nil
    end

    self:_upd_acquire_new_attention_objects(t)
    self:_upd_detect_attention_objects(t)
    self:_upd_suspicion(t)
  end
end)