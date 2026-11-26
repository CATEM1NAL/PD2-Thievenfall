function PlayerAction.ShockAndAwe.Function(player_manager, target_enemies, max_reload_increase, min_reload_increase, penalty, min_bullets, weapon_unit)
  local co = coroutine.running()
  local running = true

  local function on_player_reload(weapon_unit)
    if alive(weapon_unit) and running then
      running = false

      local reload_multiplier = max_reload_increase
      local ammo = weapon_unit:base():get_ammo_remaining_in_clip()

      if ammo > min_bullets then
        local num_bullets = ammo - min_bullets
        reload_multiplier = math.max(min_reload_increase, reload_multiplier - (penalty * num_bullets))
      end

      player_manager:set_property("shock_and_awe_reload_multiplier", reload_multiplier)
    end
  end

  local function on_switch_weapon_quit()
    running = false
  end

  player_manager:register_message(Message.OnPlayerReload, co, on_player_reload)
  player_manager:register_message(Message.OnSwitchWeapon, co, on_switch_weapon_quit)

  while running and alive(weapon_unit) and weapon_unit == player_manager:equipped_weapon_unit() do coroutine.yield(co) end

  player_manager:unregister_message(Message.OnPlayerReload, co)
  player_manager:unregister_message(Message.OnSwitchWeapon, co)
end