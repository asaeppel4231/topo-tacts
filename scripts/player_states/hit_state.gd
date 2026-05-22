extends HasAnimationsHelper
class_name HitState

@export var max_health: int = 100


var health: int

@onready var prepared_message := {"emitted-by": "HitState", "Reference": self}

func apply_damage(msg := {}) -> void:
	if msg.direct_die:
		health = 0
	take_damage(msg.amount)

func take_damage(amount: int) -> void:
	health -= amount
	if health == 0 or health < 0:
		get_actor_statemachine().change_state(actor.die_state, prepared_message)

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("HitState entered: ", msg)
	base_anim_player_play_anim("hit")
	apply_damage(msg)
	var temp := prepared_message
	temp.knockback = msg.knockback
	get_actor_statemachine().change_state(actor.knockback_state, temp)
