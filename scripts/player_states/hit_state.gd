extends HasAnimationsHelper
class_name HitState

@export var max_health: int = 100

var health: int

@onready var prepared_message := {"emitted-by": "HitState", "Reference": self}

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("HitState entered: ", msg)
	base_anim_player_play_anim("hit")
