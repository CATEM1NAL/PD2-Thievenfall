AmmoBagBase._BULLET_STORM = { 5, 10 }

Hooks:PostHook(AmmoBagBase, "init", "CrimDusk_InitAmmoBag", function(self)
  self._max_ammo_amount = tweak_data.upgrades.ammo_bag_base + managers.player:upgrade_value_by_level("ammo_bag", "ammo_increase", 3)
end)