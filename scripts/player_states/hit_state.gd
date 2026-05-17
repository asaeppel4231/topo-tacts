extends HasAnimationsHelper
class_name HitState

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("HitState entered: ", msg)
	base_anim_player_play_anim("hit")
	base.invincibly_timer.start()
