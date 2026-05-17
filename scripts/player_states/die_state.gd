extends HasAnimationsHelper
class_name DieState

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("DieState entered: ", msg)
	base_anim_player_play_anim("die")
