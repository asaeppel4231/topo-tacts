extends    IsPlayerState
class_name HitState

@onready var prepared_message := {"emitted-by": "HitState", "Reference": self}

@export var max_health: int = 100
var health: int

var already_initialized: bool = false

func apply_damage(msg := {}) -> void:
	if msg.direct_die:
		health = 0
	take_damage(msg.amount)

func take_damage(amount: int) -> void:
	health -= amount
	if health == 0 or health < 0:
		get_actor_statemachine().change_state(actor.states.die, prepared_message)

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("HitState entered: ", msg)
	if not already_initialized:
		health = max_health
		already_initialized = true
	base_anim_player_play_anim("hit")
	apply_damage(msg)
	if health <= 0:
		return
	var temp := prepared_message
	temp.knockback = msg.knockback
	get_actor_statemachine().change_state(actor.states.knockback, temp)
