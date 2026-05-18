extends HasAnimationsHelper
class_name IdleState

@onready var prepared_message := {"emitted-by": "IdleState", "Reference": self}

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("IdleState entered: ", msg)
	base_anim_player_play_anim("idle")
	actor.velocity.x = 0

func handle_input(_event):
	if actor.is_dead:
		return

	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right"):
		get_actor_statemachine().change_state(actor.run_state, {"emitted-by": "IdleState",
		"Reference": self})

	if Input.is_action_just_pressed("player_jump"):
		get_actor_statemachine().change_state(actor.jump_state, {"emitted-by": "IdleState",
		"Reference": self})

	if Input.is_action_pressed("player_duck"):
		get_actor_statemachine().change_state(actor.duck_state, {"emitted-by": "IdleState",
		"Reference": self})
