extends    IsPlayerState
class_name DuckState

@onready var prepared_message := {"emitted-by": "DuckState", "Reference": self}

func enter(_msg := {}): # msg is unused here
	base_anim_player_play_anim("duck")
	actor.velocity.x = 0

func physics_update(_delta): # delta is unused here
	var dir = base.get_move_input()

	if dir != 0:
		get_actor_statemachine().change_state(actor.states.run, prepared_message)

	if Input.is_action_just_pressed("player_jump"):
		get_actor_statemachine().change_state(actor.states.jump, prepared_message)

func exit():
	base.anim_player.play_backwards("duck")
