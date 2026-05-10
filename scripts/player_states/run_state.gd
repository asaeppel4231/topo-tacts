extends State
class_name RunState

func enter(_msg := {}): # msg is unused here
	owner.play_anim("run_loop")

func physics_update(_delta): # delta is unused here
	var dir = owner.get_move_input()

	if dir == 0:
		owner.state_machine.change_state(owner.idle_state)

	owner.player.move(dir)

	if Input.is_action_just_pressed("player_jump"):
		owner.state_machine.change_state(owner.jump_state)

	if Input.is_action_pressed("player_duck"):
		owner.state_machine.change_state(owner.duck_state)
