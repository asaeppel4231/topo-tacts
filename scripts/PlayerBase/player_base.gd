extends "res://scripts/PlayerBase/player_base_prepared_vars.gd"

@onready var is_paused    := true

#############################################
#             INPUT HANDLING                #
#############################################

func get_move_input() -> int:
	var dir = 0
	if Input.is_action_pressed("player_left"):
		dir = -1
	elif Input.is_action_pressed("player_right"):
		dir = 1
	return dir
