extends HasAnimationsHelper
class_name FlyState

@export var gravity := 900.0
@export var jump_cut_factor := 0.5   # Für variable Sprunghöhe
@export var max_fall_speed := 1200.0

@onready var prepared_message := {"emitted-by": "FlyState", "Reference": self}

func enter(msg := {}):
	if actor.velocity.x > 10:
		actor.velocity.x = 8
	if UserData.get_value("debug") == 1:
		print("FlyState entered: ", msg)

func physics_update(delta):
	if Input.is_action_just_released("player_jump") and actor.velocity.y < 0:
		actor.velocity.y *= jump_cut_factor

	var fall_multiplier: float = 1.0 + abs(actor.velocity.y) / 300.0
	actor.velocity.y += gravity * fall_multiplier * delta
	actor.velocity.y = min(actor.velocity.y, max_fall_speed)

	if actor.is_grounded() and actor.velocity.y >= 0:
		get_actor_statemachine().change_state(actor.states.run, prepared_message)
