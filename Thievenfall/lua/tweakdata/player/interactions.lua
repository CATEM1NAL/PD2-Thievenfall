local StealthBlocked = {
  money_wrap = true, gold_pile = true, carry_drop = true, painting_carry_drop = true, diamonds_pickup = true,
  hold_take_server = true, cas_take_unknown = true, cas_take_fireworks_bag = true, cas_take_empty_watertank = true,
  hold_pku_breaching_charges = true, diamond_case = true, pku_toothbrush = true, uno_hold_pku_gold = true,
  tag_take_unknown = true, gen_pku_fusion_reactor = true, hold_pku_disassemble_cro_loot = true, hold_remove_ladder = true,
  red_diamond_pickup = true, bex_prop_faberge_egg = true, bex_pku_treasure = true, chas_tea_set = true, pent_gnome_carry = true,
  corp_pickup_prototype = true, corp_hold_pku_paperpile_bag = true, driving_drive = true, hold_take_painting = true,
  gen_pku_cocaine = true, gen_pku_jewelry = true, hold_pickup_lance = true, ranc_take_weapons = true, take_weapons = true,
  gen_pku_artifact_statue = true, taking_meth = true, chas_pku_dragon_statue = true, player_zipline = true,
}

Hooks:PostHook(InteractionTweakData, "init", "CrimDusk_InteractionTweakInit", function(self)
  for interaction, _ in pairs(self) do
    if type(self[interaction]) == "table" then

      -- Interactions can be performed unmasked, some buggy ones are blocked
      if self[interaction].requires_upgrade then self[interaction].requires_mask_off_upgrade = self[interaction].requires_upgrade
      elseif not StealthBlocked[interaction] then self[interaction].requires_mask_off_upgrade = { category = "player", upgrade = "mask_off_pickup" } end

      -- Long interactions are shorter, min 5s
      if self[interaction].timer and self[interaction].timer > 5 then self[interaction].timer = math.max(self[interaction].timer * 0.5, 5) end

    end
  end

end)