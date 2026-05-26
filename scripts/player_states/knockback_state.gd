extends    IsPlayerState
class_name KnockbackState

@onready var prepared_message := {"emitted-by": "KnockbackState", "Reference": self}

@export var knockback_time := 0.15

var knockback_done  := false

var saved_knockback := Vector2.ZERO

func start_knockback() -> void:
	base.timers.knockback.start(knockback_time)

func enter(msg := {}) -> void:
	knockback_done = false
	if UserData.get_value("debug") == 1:
		print("KnockbackState entered: ", msg)
	if not base.timers.knockback.timeout.is_connected(_on_timeout):
		connect_signal(base.timers.knockback.timeout, _on_timeout)
	start_knockback()
	saved_knockback = msg.knockback

func physics_update(_delta) -> void: # delta is unused here
	if not knockback_done:
		actor.velocity = saved_knockback
		return
	elif actor.is_grounded():
		get_actor_statemachine().change_state(actor.states.run, prepared_message)
	else:
		get_actor_statemachine().change_state(actor.states.fly, prepared_message)

func _on_timeout() -> void:
	knockback_done = true
	base.timers.knockback.stop()
