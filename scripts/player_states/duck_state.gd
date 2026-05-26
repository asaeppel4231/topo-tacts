extends    IsPlayerState
class_name DuckState

@onready var prepared_message := {"emitted-by": "DuckState", "Reference": self}

func enter(msg := {}) -> void:
	if UserData.get_value("debug") == 1:
		print("RunState entered: ", msg)
	actor.velocity.x = 0
	base_anim_player_play_anim("Triax/duck")

func physics_update(_delta) -> void: # delta is unused here
	var dir = base.get_move_input()

	if dir != 0:
		get_actor_statemachine().change_state(actor.states.run, prepared_message)

	if Input.is_action_just_pressed("player_jump"):
		get_actor_statemachine().change_state(actor.states.jump, prepared_message)

func exit() -> void:
	base.anim_player.play_backwards("Triax/duck")
