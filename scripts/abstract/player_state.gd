extends State
class_name IsPlayerState

var _connections: Array = []

func connect_signal(sig: Signal, callable: Callable):
	sig.connect(callable)
	_connections.append([sig, callable])

func get_actor_statemachine():
	return actor.state_machine

func base_anim_player_play_anim(anim_name: String):
	base.anim_player.play(anim_name)

func base_anim_player_stop():
	base.anim_player.stop()

func base_anim_player_pause():
	base.anim_player.pause()

func base_anim_player_resume():
	base.anim_player.play()

func exit():
	base_anim_player_stop()
	base.idle_timer.stop()
	base.knockback_timer.stop()
	base.pause_timer.stop()
	base.invincibly_timer.stop()

	for pair in _connections:
		var sig = pair[0]
		var callable = pair[1]
		if sig.is_connected(callable):
			sig.disconnect(callable)

	_connections.clear()
