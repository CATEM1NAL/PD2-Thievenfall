Hooks:OverrideFunction(WeaponFalloffTemplate, "setup_weapon_falloff_templates", function()
  local weapon_falloff_templates = {}

  weapon_falloff_templates.SHOTGUN_FALL_PRIMARY_LOW = {
    near_falloff = 300, near_multiplier = 1,
    far_falloff = 1800, far_multiplier = 0.5,
    optimal_distance = 600, optimal_range = 600
  }
  weapon_falloff_templates.SHOTGUN_FALL_PRIMARY_MEDIUM = {
    near_falloff = 350, near_multiplier = 1,
    far_falloff = 2100, far_multiplier = 0.5,
    optimal_distance = 700, optimal_range = 700
  }
  weapon_falloff_templates.SHOTGUN_FALL_PRIMARY_HIGH = {
    near_falloff = 400, near_multiplier = 1,
    far_falloff = 2400, far_multiplier = 0.5,
    optimal_distance = 800, optimal_range = 800
  }
  weapon_falloff_templates.SNIPER_FALL_LOW = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 1000, far_multiplier = 1,
    optimal_distance = 0, optimal_range = 1500
  }
  weapon_falloff_templates.SNIPER_FALL_MEDIUM = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 1000, far_multiplier = 1,
    optimal_distance = 0, optimal_range = 2000
  }
  weapon_falloff_templates.SNIPER_FALL_HIGH = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 1000, far_multiplier = 1,
    optimal_distance = 0, optimal_range = 2500
  }
  weapon_falloff_templates.SNIPER_FALL_VERYHIGH = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 500, far_multiplier = 1,
    optimal_distance = 0, optimal_range = 2500
  }
  weapon_falloff_templates.LMG_FALL_MEDIUM = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 1700, far_multiplier = 0.7,
    optimal_distance = 0, optimal_range = 1700
  }
  weapon_falloff_templates.LMG_FALL_HIGH = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 1800, far_multiplier = 0.8,
    optimal_distance = 0, optimal_range = 1800
  }
  weapon_falloff_templates.AKI_PISTOL_FALL_AUTO = {
    near_falloff = 250, near_multiplier = 1,
    far_falloff = 1500, far_multiplier = 0.75,
    optimal_distance = 500, optimal_range = 500
  }
  weapon_falloff_templates.AKI_PISTOL_FALL_LOW = {
    near_falloff = 300, near_multiplier = 1,
    far_falloff = 1800, far_multiplier = 0.75,
    optimal_distance = 600, optimal_range = 600
  }
  weapon_falloff_templates.AKI_PISTOL_FALL_MEDIUM = {
    near_falloff = 350, near_multiplier = 1,
    far_falloff = 2100, far_multiplier = 0.75,
    optimal_distance = 700, optimal_range = 700
  }
  weapon_falloff_templates.AKI_PISTOL_FALL_HIGH = {
    near_falloff = 400, near_multiplier = 1,
    far_falloff = 2400, far_multiplier = 0.75,
    optimal_distance = 800, optimal_range = 800
  }
  weapon_falloff_templates.AKI_PISTOL_FALL_VERYHIGH = {
    near_falloff = 425, near_multiplier = 1,
    far_falloff = 2550, far_multiplier = 0.75,
    optimal_distance = 850, optimal_range = 850
  }
  weapon_falloff_templates.AKI_SMG_FALL_LOW = {
    near_falloff = 350, near_multiplier = 1,
    far_falloff = 2100, far_multiplier = 0.75,
    optimal_distance = 700, optimal_range = 700
  }
  weapon_falloff_templates.AKI_SMG_FALL_MEDIUM = {
    near_falloff = 400, near_multiplier = 1,
    far_falloff = 2400, far_multiplier = 0.75,
    optimal_distance = 800, optimal_range = 800
  }
  weapon_falloff_templates.AKI_SMG_FALL_HIGH = {
    near_falloff = 425, near_multiplier = 1,
    far_falloff = 2550, far_multiplier = 0.75,
    optimal_distance = 850, optimal_range = 850
  }
  weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_LOW = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 300, far_multiplier = 0.6,
    optimal_distance = 600, optimal_range = 500
  }
  weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_MEDIUM = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 300, far_multiplier = 0.6,
    optimal_distance = 700, optimal_range = 500
  }
  weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_HIGH = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 300, far_multiplier = 0.6,
    optimal_distance = 700, optimal_range = 500
  }
  weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_VERYHIGH = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 400, far_multiplier = 0.7,
    optimal_distance = 800, optimal_range = 600
  }
  weapon_falloff_templates.SPECIAL_LOW = {
    near_falloff = 0, near_multiplier = 1,
    far_falloff = 300, far_multiplier = 0.6,
    optimal_distance = 0, optimal_range = 1500
  }

  weapon_falloff_templates.SMG_FALL_LOW = deep_clone(weapon_falloff_templates.AKI_SMG_FALL_LOW)
  weapon_falloff_templates.SMG_FALL_MEDIUM = deep_clone(weapon_falloff_templates.AKI_SMG_FALL_MEDIUM)
  weapon_falloff_templates.SMG_FALL_HIGH = deep_clone(weapon_falloff_templates.AKI_SMG_FALL_HIGH)

  weapon_falloff_templates.PISTOL_FALL_AUTO = deep_clone(weapon_falloff_templates.AKI_PISTOL_FALL_AUTO)
  weapon_falloff_templates.PISTOL_FALL_LOW = deep_clone(weapon_falloff_templates.AKI_PISTOL_FALL_LOW)
  weapon_falloff_templates.PISTOL_FALL_MEDIUM = deep_clone(weapon_falloff_templates.AKI_PISTOL_FALL_MEDIUM)
  weapon_falloff_templates.PISTOL_FALL_HIGH = deep_clone(weapon_falloff_templates.AKI_PISTOL_FALL_HIGH)
  weapon_falloff_templates.PISTOL_FALL_VERYHIGH = deep_clone(weapon_falloff_templates.AKI_PISTOL_FALL_VERYHIGH)

  weapon_falloff_templates.AKI_SHOTGUN_FALL_LOW = deep_clone(weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_LOW)
  weapon_falloff_templates.AKI_SHOTGUN_FALL_MEDIUM = deep_clone(weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_MEDIUM)
  weapon_falloff_templates.AKI_SHOTGUN_FALL_HIGH = deep_clone(weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_HIGH)
  weapon_falloff_templates.AKI_SHOTGUN_FALL_VERYHIGH = deep_clone(weapon_falloff_templates.SHOTGUN_FALL_SECONDARY_VERYHIGH)

  return weapon_falloff_templates
end)