extends CharacterBody2D

@onready var raycasts        = {
	"far_ground":            get_node("FarGroundRay") ,
	"ground"    : {
		"left"  :            get_node("GroundRayLeft"),
		"right":             get_node("GroundRayRight")              
	}
}

@onready var state_machine    := $StateMachine

@onready var states           = {
	"run"      :             state_machine.get_node("RunState")      ,
	"jump"     :             state_machine.get_node("JumpState")     ,
	"hit"      :             state_machine.get_node("HitState")      ,
	"knockback":             state_machine.get_node("KnockbackState"),
	"fly"      :             state_machine.get_node("FlyState")      ,
	"duck"     :             state_machine.get_node("DuckState")     ,
	"idle"     :             state_machine.get_node("IdleState")     ,
	"die"      :             state_machine.get_node("DieState")
}

@onready var player_cam       := $PlayerCamera

@onready var flip_node        := $FlipNode
@onready var models           := flip_node.get_node("Models")
@onready var image            := models.get_node("Image")
@onready var hitbox           := models.get_node("Hitbox")

@onready var hitbox_collision := $Hitbox_collision

func check_raycasts_exists() -> bool:
	var has_error = false
	if raycasts == null: # alternative: if not raycasts, same pattern for following if checks 
		push_error("[PREPARED VARS FOR PLAYER] Raycast dictionary is null!!!")
		has_error = true
	else:
		if raycasts["far_ground"] == null:
			push_error("[PREPARED VARS FOR PLAYER] Raycast far_ground is not existent!!!")
			has_error = true
		elif raycasts["far_ground"] is not RayCast2D:
			push_error("[PREPARED VARS FOR PLAYER] Raycast far_ground is existent, but not of type RayCast2D!!!")
			has_error = true
		if raycasts["ground"] == null:
			push_error("[PREPARED VARS FOR PLAYER] Raycast dictionary ground entry is null!!!")
			has_error = true
		if raycasts["ground"]["left"] == null:
			push_error("[PREPARED VARS FOR PLAYER] Raycast ground_left is not existent!!!")
			has_error = true
		elif raycasts["ground"]["left"] is not RayCast2D:
			push_error("[PREPARED VARS FOR PLAYER] Child ground left is existent, but not of type RayCast2D!!!")
			has_error = true
		if raycasts["ground"]["right"] == null:
			push_error("[PREPARED VARS FOR PLAYER] Raycast ground_right is not existent!!!")
			has_error = true
		elif raycasts["ground"]["right"] is not RayCast2D:
			push_error("[PREPARED VARS FOR PLAYER] Child ground right is existent, but not of type RayCast2D!!!")
			has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_state_machine_exists() -> bool:
	var has_error = false
	if state_machine == null: # alternative: if not state_machine
		push_error("[PREPARED VARS FOR PLAYER] State Machine Node is not existent!!!")
		has_error = true
	elif state_machine is not StateMachine:
		push_error("[PREPARED VARS FOR PLAYER] State Machine Node is existent, but not a StateMachine!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_states_exists() -> bool:
	var has_error = false
	if states == null: # alternative: if not states, same pattern for following if checks 
		push_error("[PREPARED VARS FOR PLAYER] States dictionary is null!!!")
		has_error = true
	else:
		if states.run == null:
			push_error("[PREPARED VARS FOR PLAYER] Run State Node is not existent!!!")
			has_error = true
		elif states.run is not RunState:
			push_error("[PREPARED VARS FOR PLAYER] Run State Node is existent, but not a RunState!!!")
			has_error = true
		if states.jump == null:
			push_error("[PREPARED VARS FOR PLAYER] Jump State Node is not existent!!!")
			has_error = true
		elif states.jump is not JumpState:
			push_error("[PREPARED VARS FOR PLAYER] Jump State Node is existent, but not a JumpState!!!")
			has_error = true
		if states.hit == null:
			push_error("[PREPARED VARS FOR PLAYER] Hit State Node is not existent!!!")
			has_error = true
		elif states.hit is not HitState:
			push_error("[PREPARED VARS FOR PLAYER] Hit State Node is existent, but not a HitState!!!")
			has_error = true
		if states.knockback == null:
			push_error("[PREPARED VARS FOR PLAYER] Knockback State Node is not existent!!!")
			has_error = true
		elif states.knockback is not KnockbackState:
			push_error("[PREPARED VARS FOR PLAYER] Knockback State Node is existent, but not a KnockbackState!!!")
			has_error = true
		if states.fly == null:
			push_error("[PREPARED VARS FOR PLAYER] Fly State Node is not existent!!!")
			has_error = true
		elif states.fly is not FlyState:
			push_error("[PREPARED VARS FOR PLAYER] Fly State Node is existent, but not a FlyState!!!")
			has_error = true
		if states.duck == null:
			push_error("[PREPARED VARS FOR PLAYER] Duck State Node is not existent!!!")
			has_error = true
		elif states.duck is not DuckState:
			push_error("[PREPARED VARS FOR PLAYER] Duck State Node is existent, but not a DuckState!!!")
			has_error = true
		if states.idle == null:
			push_error("[PREPARED VARS FOR PLAYER] Idle State Node is not existent!!!")
			has_error = true
		elif states.idle is not IdleState:
			push_error("[PREPARED VARS FOR PLAYER] Idle State Node is existent, but not an IdleState!!!")
			has_error = true
		if states.die == null:
			push_error("[PREPARED VARS FOR PLAYER] Die State Node is not existent!!!")
			has_error = true
		elif states.die is not DieState:
			push_error("[PREPARED VARS FOR PLAYER] Die State Node is existent, but not a DieState!!!")
			has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_player_cam_exists() -> bool:
	var has_error = false
	if player_cam == null: # alternative: if not player_cam
		push_error("[PREPARED VARS FOR PLAYER] Player Camera Node is not existent!!!")
		has_error = true
	elif player_cam is not Camera2D:
		push_error("[PREPARED VARS FOR PLAYER] Player Camera Node is existent, but not a Camera2D!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_flip_node_and_children_exists() -> bool:
	var has_error = false
	if flip_node == null: # alternative: if not flip_node, same pattern for following if checks
		push_error("[PREPARED VARS FOR PLAYER] Player Flip Node is not existent!!!")
		has_error = true
	elif flip_node is not Node2D:
		push_error("[PREPARED VARS FOR PLAYER] Player Flip Node is existent, but not a Node2D!!!")
		has_error = true
	else:
		if models == null:
			push_error("[PREPARED VARS FOR PLAYER] Player Models Node is not existent!!!")
			has_error = true
		elif models is not Node2D:
			push_error("[PREPARED VARS FOR PLAYER] Player Models Node is existent, but not a Node2D!!!")
			has_error = true
		else:
			if image == null:
				push_error("[PREPARED VARS FOR PLAYER] Player Image Node is not existent!!!")
				has_error = true
			elif image is not Sprite2D:
				push_error("[PREPARED VARS FOR PLAYER] Player Image Node is existent, but not a Sprite2D!!!")
				has_error = true
			if hitbox == null:
				push_error("[PREPARED VARS FOR PLAYER] Player Hitbox Node is not existent!!!")
				has_error = true
			elif hitbox is not Area2D:
				push_error("[PREPARED VARS FOR PLAYER] Player Hitbox Node is existent, but not an Area2D!!!")
				has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_hitbox_collision_exists() -> bool:
	var has_error = false 
	if hitbox_collision == null: # alternative: if not hitbox_collision
		push_error("[PREPARED VARS FOR PLAYER] Player Hitbox Collision Node is not existent!!!")
		has_error = true
	elif hitbox_collision is not CollisionShape2D:
		push_error("[PREPARED VARS FOR PLAYER] Player Hitbox Collision Node is existent, but not a CollisionShape2D!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_all() -> bool:
	return ( check_raycasts_exists() and check_state_machine_exists() and check_states_exists()
		and check_player_cam_exists() and check_flip_node_and_children_exists()
		and check_hitbox_collision_exists() and hitbox.check_hitbox_hitted_exists())
