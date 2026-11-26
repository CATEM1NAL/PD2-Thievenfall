-- Player colours
local player1 = Global.CrimDusk.archicolours.blue
local player2 = Global.CrimDusk.archicolours.pink
local player3 = Global.CrimDusk.archicolours.red
local player4 = Global.CrimDusk.archicolours.yellow
local team_ai = Global.CrimDusk.archicolours.orange

tweak_data.peer_vector_colors[1] = player1
tweak_data.chat_colors[1] = player1
tweak_data.preplanning_peer_colors[1] = Global.CrimDusk.archicolours.blue_alt

tweak_data.peer_vector_colors[2] = player2
tweak_data.chat_colors[2] = player2
tweak_data.preplanning_peer_colors[2] = Global.CrimDusk.archicolours.pink_alt

tweak_data.peer_vector_colors[3] = player3
tweak_data.chat_colors[3] = player3
tweak_data.preplanning_peer_colors[3] = Global.CrimDusk.archicolours.red_alt

tweak_data.peer_vector_colors[4] = player4
tweak_data.chat_colors[4] = player4
tweak_data.preplanning_peer_colors[4] = Global.CrimDusk.archicolours.yellow_alt

tweak_data.peer_vector_colors[5] = team_ai
tweak_data.chat_colors[5] = team_ai

-- Spy camera feed colour
for i = 1, #tweak_data.chat_colors - 1 do
  local theme_id = "spy_camera_peer_" .. i

  tweak_data.camera_themes[theme_id] = clone(tweak_data.camera_themes.spy_camera)
  tweak_data.camera_themes[theme_id].tint_color = tweak_data.chat_colors[i]:with_alpha(0.2)
end

-- Other menu colours
tweak_data.system_chat_color = Global.CrimDusk.archicolours.orange

tweak_data.screen_colors.resource = Global.CrimDusk.archicolours.red
tweak_data.screen_colors.button_stage_2 = Global.CrimDusk.archicolours.orange
tweak_data.screen_colors.button_stage_3 = Global.CrimDusk.archicolours.red
tweak_data.screen_colors.risk = Global.CrimDusk.archicolours.yellow
tweak_data.screen_colors.ghost_color = Global.CrimDusk.archicolours.red

-- XP curve
tweak_data.experience_manager.levels = {}
local xp = 1000
for i = 1, 100 do
  tweak_data.experience_manager.levels[i] = { points = xp }
  xp = 1000 * (i + 1)
end

-- XP tweaks
tweak_data.experience_manager.prestige_xp_max = 5000000
tweak_data.experience_manager.difficulty_multiplier = { 1, 1.5, 2, 2.5, 3, 3.5, 5 }
tweak_data.experience_manager.level_limit.pc_difference_multipliers = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
tweak_data.experience_manager.level_limit.low_cap_multiplier = 1

-- Projectile damage
for proj, dmg in pairs(Global.CrimDusk.weapons.projectile_damage) do
  tweak_data.projectiles[proj].damage = dmg
  if tweak_data.projectiles[proj].player_damage then tweak_data.projectiles[proj].player_damage = dmg * 0.1 end
  if tweak_data.projectiles[proj].poison_gas_duration then tweak_data.projectiles[proj].poison_gas_duration = 5 end
end

tweak_data.projectiles.poison_gas_grenade.poison_gas_duration = 15

-- Projectile speed
tweak_data.projectiles.frag.launch_speed = 300
tweak_data.projectiles.concussion.launch_speed = 300
tweak_data.projectiles.fir_com.launch_speed = 300
tweak_data.projectiles.smoke_screen_grenade.launch_speed = 300
tweak_data.projectiles.poison_gas_grenade.launch_speed = 300
tweak_data.projectiles.sticky_grenade.launch_speed = 300
tweak_data.projectiles.frag_com.launch_speed = 400

tweak_data.team_ai.stop_action.distance = 10000 -- Crew AI will only start following you after you go 100m away (vanilla is 30m)

-- Medic rework; medics have no cooldown but have half range
tweak_data.medic.radius = 200
tweak_data.medic.cooldown = 0

tweak_data:digest_tweak_data()