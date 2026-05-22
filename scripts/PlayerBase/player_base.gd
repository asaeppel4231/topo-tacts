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

#############################################
#                 EVENTS                    #
#############################################

func _on_idle_timer_timeout():
	on_timeout_idle_timer.call()

func _on_invincibly_timer_timeout() -> void:
	on_timeout_invincibly_timer.call()

func _on_knockback_timer_timeout() -> void:
	on_timeout_knockback_timer.call()

func _on_pause_timer_timeout() -> void:
	on_timeout_pause_timer.call()

func _on_hitbox_body_entered(_body: Node2D) -> void: # body is unused here
	pass
