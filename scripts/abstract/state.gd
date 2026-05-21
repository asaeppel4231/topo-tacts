extends Node
class_name State

var actor
var base

func is_grounded() -> bool:
	return actor.ground_ray_left.is_colliding() or actor.ground_ray_right.is_colliding()

func get_actor_statemachine():
	return actor.state_machine

func base_anim_player_play_anim(anim_name: String):
	base.anim_player.play(anim_name)

func base_anim_player_stop():
	base.anim_player.stop()

func base_anim_player_pause():
	base.anim_player.pause()

func base_anim_player_resume():
	base.anim_player.play()

func enter(_msg := {}): # msg is unused here
	pass

func exit():
	pass

func handle_input(_event): # event is unused here
	pass

func update(_delta): # delta is unused here
	pass

func physics_update(_delta): # delta is unused here
	pass
