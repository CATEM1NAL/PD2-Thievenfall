Hooks:OverrideFunction(HuskPlayerDamage, "damage_bullet", function(self, attack_data)
  self:_send_damage_to_owner(attack_data)
end)

Hooks:OverrideFunction(HuskPlayerDamage, "damage_melee", function(self, attack_data)
  self:_send_damage_to_owner(attack_data)
end)

Hooks:OverrideFunction(HuskPlayerDamage, "damage_fire", function(self, attack_data)
  self:_send_damage_to_owner(attack_data)
end)

Hooks:OverrideFunction(HuskPlayerDamage, "_send_damage_to_owner", function(self, attack_data)
  local peer_id = managers.criminals:character_peer_id_by_unit(self._unit)
  local difficulty = (tweak_data:difficulty_to_index(Global.game_settings.difficulty) or 2) - 1
  local damage = attack_data.damage * Global.CrimDusk.friendly_fire[difficulty]

  managers.network:session():send_to_peers("sync_friendly_fire_damage", peer_id, attack_data.attacker_unit, damage, attack_data.variant)
  if attack_data.attacker_unit == managers.player:player_unit() then managers.hud:on_hit_confirmed() end

  managers.job:set_memory("trophy_flawless", true, false)
end)