extends    IsPlayerState
class_name PauseState

func enter(_msg := {}) -> void:
	base_anim_player_pause()
	base.pause_timer.stop()
