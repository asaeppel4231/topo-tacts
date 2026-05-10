extends State
class_name IdleState

func enter(_msg := {}): # msg is unused here
	owner.play_anim("idle")
	owner.player.velocity.x = 0

func handle_input(_event): # event is unused here
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right"):
		owner.state_machine.change_state(owner.run_state)

	if Input.is_action_just_pressed("player_jump"):
		owner.state_machine.change_state(owner.jump_state)

	if Input.is_action_pressed("player_duck"):
		owner.state_machine.change_state(owner.duck_state)
