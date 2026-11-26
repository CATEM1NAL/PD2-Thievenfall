Hooks:PostHook(AssetsTweakData, "_init_assets", "CrimDusk_InitAssetTweak", function(self)
  -- Remove unneeded assets
  self.grenade_crate.stages = {}
  self.safe_escape.stages = {}
  self.nightclub_badmusic.stages = {}
  self.camera_access.stages = {}
  self.roberts_plan_a.stages = {}
  self.sah_cutter.stages = {}
  self.bodybags_bag.stages = { "welcome_to_the_jungle_2", "election_day_2", "firestarter_2", "family", "cage", "dark", "fish", "dah", "tag" }
  for _, asset in pairs(self) do asset.upgrade_lock = nil end
end)