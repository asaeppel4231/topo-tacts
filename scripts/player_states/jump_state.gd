extends State
class_name JumpState

func enter(_msg := {}): # msg is unused here
	owner.play_anim("jump")
	owner.player.jump()

func physics_update(_delta): # delta is unused here
	if owner.player.is_on_floor():
		owner.state_machine.change_state(owner.idle_state)
