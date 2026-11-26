-- Force last life effect for use with down time
Hooks:OverrideFunction(CoreEnvironmentControllerManager, "set_last_life", function(self)
  self._last_life = CrimDusk.SettingsData.greyscreen
end)