Hooks:OverrideFunction(TripMineBase, "_sensor", function(self, t)
  local ray = self:_raycast()

  if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
    self._sensor_units_detected = self._sensor_units_detected or {}

    if not self._sensor_units_detected[ray.unit:key()] then
      self._sensor_units_detected[ray.unit:key()] = true

      -- Sensor now highlights ALL npcs, even in loud
      if managers.player:has_category_upgrade("trip_mine", "sensor_highlight") then
        managers.game_play_central:auto_highlight_enemy(ray.unit, true)
        self:_emit_sensor_sound_and_effect()

        if managers.network:session() then
          managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", TripMineBase.EVENT_IDS.sensor_beep)
        end

      end

      self._sensor_last_unit_time = t + 5
    end
  end
end)