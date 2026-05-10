extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State

func _ready():
	change_state(initial_state)

func change_state(new_state: State, msg := {}):
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.owner = owner
	current_state.enter(msg)

func _input(event):
	if owner.is_paused:
		return
	if current_state:
		current_state.handle_input(event)

func _process(delta):
	if owner.is_paused:
		return
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if owner.is_paused:
		return
	if current_state:
		current_state.physics_update(delta)
