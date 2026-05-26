extends Node
class_name State

var actor
var base

var interruptible := true
var allowed_transitions := []

func enter(_msg := {}) -> void: # msg is unused here
	pass

func exit():
	pass

func handle_input(_event) -> void: # event is unused here
	pass

func update(_delta) -> void: # delta is unused here
	pass

func physics_update(_delta) -> void: # delta is unused here
	pass
