local player = managers.player:player_unit()
local PlayerState = player and player:movement() and player:movement():current_state()
if not PlayerState or PlayerState:_interacting() or PlayerState:is_deploying() then return end

local ValidState = { standard = true, carry = true }
if ValidState[managers.player:current_state()] and PlayerState:_melee_repeat_allowed() then
  local t = managers.player:player_timer():time()
  PlayerState:_interupt_action_reload(t)

  local CurrentMelee = managers.blackmarket:equipped_melee_weapon()

  Global.blackmarket_manager.melee_weapons[CurrentMelee].equipped = false
  Global.blackmarket_manager.melee_weapons.weapon.equipped = true
  Global.blackmarket_manager.melee_weapons.weapon.unlocked = true

  PlayerState:_do_action_melee(t)

  Global.blackmarket_manager.melee_weapons[CurrentMelee].equipped = true
  Global.blackmarket_manager.melee_weapons.weapon.equipped = false
  Global.blackmarket_manager.melee_weapons.weapon.unlocked = false
end
