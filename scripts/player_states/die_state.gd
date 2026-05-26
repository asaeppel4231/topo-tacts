extends    IsPlayerState
class_name DieState

@onready var prepared_message := {"emitted-by": "DieState", "Reference": self}

func enter(msg := {}) -> void:
	if UserData.get_value("debug") == 1:
		print("DieState entered: ", msg)
	actor.velocity = Vector2.ZERO
	base_anim_player_play_anim("Triax/die")
