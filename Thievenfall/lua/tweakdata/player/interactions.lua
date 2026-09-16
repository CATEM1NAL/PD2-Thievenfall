if Global.game_settings and Global.game_settings.level_id == "flat" then return end

Hooks:PostHook(InteractionTweakData, "init", "CrimDusk_InteractionTweakInit", function(self)
  for interaction, _ in pairs(self) do
    if type(self[interaction]) == "table" then

      -- ALL instant interactions can be performed unmasked
      if self[interaction].requires_upgrade then self[interaction].requires_mask_off_upgrade = self[interaction].requires_upgrade
      else self[interaction].requires_mask_off_upgrade = { category = "player", upgrade = "mask_off_pickup" } end

      -- Long interactions are shorter, min 5s
      if self[interaction].timer and self[interaction].timer > 5 then self[interaction].timer = math.max(self[interaction].timer * 0.5, 5) end

    end
  end

end)