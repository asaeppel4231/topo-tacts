extends State
class_name IsPlayerState

var _connections: Array = []

###########################################################
#                       UTILITIES                         #
###########################################################

func connect_signal(sig: Signal, callable: Callable) -> void:
	sig.connect(callable)
	_connections.append([sig, callable])

func get_actor_statemachine() -> StateMachine:
	return actor.state_machine

func base_anim_player_play_anim(anim_name: String) -> void:
	base.anim_player.play(anim_name)

func base_anim_player_stop() -> void:
	base.anim_player.stop()

func base_anim_player_pause() -> void:
	base.anim_player.pause()

func base_anim_player_resume() -> void:
	base.anim_player.play()

func exit() -> void:
	base.timers.idle.stop()
	base.timers.knockback.stop()

	for pair in _connections:
		var sig = pair[0]
		var callable = pair[1]
		if sig.is_connected(callable):
			sig.disconnect(callable)

	_connections.clear()
