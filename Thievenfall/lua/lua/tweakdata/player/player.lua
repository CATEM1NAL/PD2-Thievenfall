Hooks:PostHook(PlayerTweakData, "init", "CrimDusk_InitPlayerTweakData", function(self)
  self.damage.HEALTH_INIT = 10
  self.damage.LIVES_INIT = 1 + Global.CrimDusk.data["lives" .. CrimDusk.IsPermadeath()]

  -- Movement
  self.gravity = -1800
  self.movement_state.standard.movement.jump_velocity.z = 650

  -- Sixth Sense
  self.omniscience.start_t = 1
  self.omniscience.target_resense_t = 5

  --[[ Camera heights
  self.stances.default.standard.head.translation = Vector3(0, 0, 160)
  self.stances.default.mask_off.head.translation = Vector3(0, 0, 170)
  self.stances.default.crouched.head.translation = Vector3(0, 0, 100)
  ]]

  -- Pager settings
  self.alarm_pager = {
    first_call_delay = 3,
    call_duration = 4, nr_of_calls = 3,
    bluff_success_chance = { 1, 1, 1, 1, 0 } -- Kept as table for compatibility reasons
  }
end)

Hooks:PostHook(PlayerTweakData, "_set_normal", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.automatic_respawn_time = nil
  self.damage.ARRESTED_TIME = 10
  self.damage.MIN_DAMAGE_INTERVAL = 2
  self.damage.REVIVE_HEALTH_STEPS = { 1, 0.5 }
end)

Hooks:PostHook(PlayerTweakData, "_set_hard", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.automatic_respawn_time = nil
  self.damage.ARRESTED_TIME = 15
  self.damage.MIN_DAMAGE_INTERVAL = 1.5
  self.damage.REVIVE_HEALTH_STEPS = { 0.9, 0.5 }
  
  self.alarm_pager.call_duration = 3.75
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 1
  self.damage.TASED_TIME = 8
  self.damage.ARRESTED_TIME = 20
  self.damage.REVIVE_HEALTH_STEPS = { 0.8, 0.4 }

  self.alarm_pager.call_duration = 3.5
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_145", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.75
  self.damage.TASED_TIME = 6
  self.damage.ARRESTED_TIME = 25
  self.damage.REVIVE_HEALTH_STEPS = { 0.7, 0.3 }

  self.alarm_pager.call_duration = 3.25
end)

Hooks:PostHook(PlayerTweakData, "_set_easy_wish", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.5
  self.damage.TASED_TIME = 4
  self.damage.ARRESTED_TIME = 30
  self.damage.REVIVE_HEALTH_STEPS = { 0.6, 0.2 }

  self.alarm_pager.call_duration = 3
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.25
  self.damage.TASED_TIME = 3
  self.damage.ARRESTED_TIME = 35
  self.damage.REVIVE_HEALTH_STEPS = { 0.5, 0.1 }

  self.alarm_pager.call_duration = 2.75
end)

Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0
  self.damage.TASED_TIME = 2
  self.damage.ARRESTED_TIME = 40
  self.damage.REVIVE_HEALTH_STEPS = { 0.5, 0.01 }

  self.alarm_pager.call_duration = 2.5
end)