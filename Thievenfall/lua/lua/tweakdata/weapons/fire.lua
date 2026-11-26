Hooks:PreHook(FireTweakData, "_process_dot_entries", "CrimDawn_FireTweakProcess", function(self)
  for weapon, dmg in pairs(Global.CrimDusk.weapons.fire_damage) do self.dot_entries.fire[weapon].dot_damage = dmg end
  self.dot_entries.fire.ammo_dragons_breath.dot_trigger_max_distance = 1000
end)