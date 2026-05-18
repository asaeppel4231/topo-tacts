extends HasAnimationsHelper
class_name DieState

@onready var prepared_message := {"emitted-by": "DieState", "Reference": self}

func enter(msg := {}):
	base_anim_player_stop()
	if UserData.get_value("debug") == 1:
		print("DieState entered: ", msg)
	base_anim_player_play_anim("die")
