extends State
class_name KnockbackState

@onready var prepared_message := {"emitted-by": "KnockbackState", "Reference": self}

func enter(msg := {}):
	owner.play_anim("hurt")
	owner.player.apply_knockback(msg.knockback)

func physics_update(delta):
	if owner.player.is_on_floor():
		owner.state_machine.change_state(owner.idle_state, prepared_message)
