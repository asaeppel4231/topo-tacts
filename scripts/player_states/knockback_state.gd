extends State
class_name KnockbackState

@onready var prepared_message := {"emitted-by": "KnockbackState", "Reference": self}

@export var knockback_time := 0.15

var knockback_time_left := 1.0

var msg2 := {}

func apply_knockback() -> void:
	knockback_time_left = knockback_time

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("KnockbackState entered: ", msg)
	base_anim_player_play_anim("hurt")
	apply_knockback()
	msg2 = msg

func physics_update(delta):
	knockback_time_left -= delta
	if actor.is_grounded():
		get_actor_statemachine().change_state(actor.states.run, prepared_message)
	elif knockback_time_left <= 0.0:
		get_actor_statemachine().change_state(actor.states.fly, prepared_message)
	if msg2:
		actor.velocity = msg2.knockback
