extends State
class_name DuckState

func enter(_msg := {}): # msg is unused here
	owner.play_anim("duck")
	owner.player.velocity.x = 0

func physics_update(_delta): # delta is unused here
	var dir = owner.get_move_input()

	# 1. Duck loslassen → Unduck
	if not Input.is_action_pressed("player_duck"):
#		owner.state_machine.change_state(owner.unduck_state)
		return

	# 2. Bewegung → Unduck + Run
	if dir != 0:
		owner.state_machine.change_state(owner.unduck_state, {"next": "run"})
		return

	# 3. Jump → JumpState
	if Input.is_action_just_pressed("player_jump"):
		owner.state_machine.change_state(owner.jump_state)
