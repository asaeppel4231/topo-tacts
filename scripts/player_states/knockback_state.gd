extends    IsPlayerState
class_name KnockbackState

@onready var prepared_message := {"emitted-by": "KnockbackState", "Reference": self}

@export var knockback_time := 0.15

var knockback_done  := false

var saved_knockback := Vector2.ZERO

func start_knockback() -> void:
	base.knockback_timer.start(knockback_time)

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("KnockbackState entered: ", msg)
	base_anim_player_play_anim("hurt")
	connect_signal(base.knockback_timer.timeout, _on_timeout)
	start_knockback()
	saved_knockback = msg.knockback

func physics_update(_delta): # delta is unused here
	if not knockback_done:
		actor.velocity = saved_knockback
		return
	elif actor.is_grounded():
		get_actor_statemachine().change_state(actor.states.run, prepared_message)
	else:
		get_actor_statemachine().change_state(actor.states.fly, prepared_message)

func _on_timeout():
	knockback_done = true
	base.knockback_timer.stop()
