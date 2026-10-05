Hooks:PostHook(PlayerTweakData, "init", "CrimDusk_InitPlayerTweakData", function(self)
  self.damage.HEALTH_INIT = 10
  self.damage.LIVES_INIT = 1 + Global.CrimDusk.data["lives" .. CrimDusk.IsPermadeath()]
  self.gravity = -1800
  self.movement_state.standard.movement.jump_velocity.z = 650
  self.omniscience.start_t = 1
  self.omniscience.target_resense_t = 5
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
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 1
  self.damage.TASED_TIME = 8
  self.damage.ARRESTED_TIME = 20
  self.damage.REVIVE_HEALTH_STEPS = { 0.8, 0.4 }
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_145", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.75
  self.damage.TASED_TIME = 6
  self.damage.ARRESTED_TIME = 25
  self.damage.REVIVE_HEALTH_STEPS = { 0.7, 0.3 }
end)

Hooks:PostHook(PlayerTweakData, "_set_easy_wish", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.5
  self.damage.TASED_TIME = 4
  self.damage.ARRESTED_TIME = 30
  self.damage.REVIVE_HEALTH_STEPS = { 0.6, 0.2 }
end)

Hooks:PostHook(PlayerTweakData, "_set_overkill_290", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0.25
  self.damage.TASED_TIME = 3
  self.damage.ARRESTED_TIME = 35
  self.damage.REVIVE_HEALTH_STEPS = { 0.5, 0.1 }
end)

Hooks:PostHook(PlayerTweakData, "_set_sm_wish", "CrimDusk_PlayerTweakSetDifficulty", function(self)
  self.damage.MIN_DAMAGE_INTERVAL = 0
  self.damage.TASED_TIME = 2
  self.damage.ARRESTED_TIME = 40
  self.damage.REVIVE_HEALTH_STEPS = { 0.5, 0.01 }
end)