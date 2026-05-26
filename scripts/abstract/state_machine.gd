extends Node
class_name StateMachine

var current_state: State
var actor: Node
var base: Node

func change_state(new_state: State, msg := {}) -> void:
	if current_state != new_state:
		if current_state:
			current_state.exit()
		current_state = new_state
		current_state.actor = actor
		current_state.base = base
		current_state.enter(msg)

func _input(event) -> void:
	if base and base.is_paused:
		return
	if current_state:
		current_state.handle_input(event)

func _process(delta) -> void:
	if base and base.is_paused:
		return
	if current_state:
		current_state.update(delta)

func _physics_process(delta) -> void:
	if base and base.is_paused:
		return
	if current_state:
		current_state.physics_update(delta)
