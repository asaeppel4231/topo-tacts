extends State
class_name PauseState

func enter(_msg := {}):
	base_anim_player_pause()
	base.pause_timer.stop()
