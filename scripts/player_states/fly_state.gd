extends HasAnimationsHelper
class_name FlyState

@export var gravity := 900.0
@export var jump_cut_factor := 0.5   # Für variable Sprunghöhe
@export var max_fall_speed := 1200.0

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("FlyState entered: ", msg)

func physics_update(delta):
	if actor.is_dead:
		return

	# Variable Sprunghöhe (Taste loslassen)
	if Input.is_action_just_released("player_jump") and actor.velocity.y < 0:
		actor.velocity.y *= jump_cut_factor

	# Schwerkraft
	actor.velocity.y += gravity * delta

	# Maximalgeschwindigkeit nach unten
	actor.velocity.y = min(actor.velocity.y, max_fall_speed)

	# Landen
	if actor.is_on_floor():
		get_actor_statemachine().change_state(actor.run_state, {"emitted-by": "FlyState",
		"Reference": self})
