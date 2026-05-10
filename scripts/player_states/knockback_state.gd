extends State
class_name KnockbackedState

func enter(msg := {}):
	owner.play_anim("hurt")
	owner.player.apply_knockback(msg.knockback)

func physics_update(delta):
	if owner.player.is_on_floor():
		owner.state_machine.change_state(owner.idle_state)
