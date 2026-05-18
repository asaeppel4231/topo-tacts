extends HasMovementHelper
class_name RunState

var dir      := 0

var timer_started := false

@export var max_speed     := 600.0
@export var speed_increase:=   2.3
@export var default_speed := 200.0

@export var disable_speed_limit := false

@onready var prepared_message := {"emitted-by": "RunState", "Reference": self}

func move(direction: int):
	actor.velocity.x = lerp(actor.velocity.x, direction * actor.speed, 0.2)

func increase_speed():
	if disable_speed_limit:
		actor.speed += speed_increase
	elif actor.speed <= (max_speed - speed_increase):
		actor.speed += speed_increase

func decrease_speed_if_limit_activated():
	if disable_speed_limit:
		return
	if actor.speed > 0:
		actor.speed -= speed_increase

func enter(msg := {}):
	dir = 0
	actor.speed = default_speed
	if UserData.get_value("debug") == 1:
		print("RunState entered: ", msg)
	if msg.get("emitted-by") == "IdleState":
		base_anim_player_play_anim("run_start")
		actor.flip_node.scale.x = dir
		await base.anim_player.animation_finished
		base_anim_player_play_anim("run_loop")
	else:
		base_anim_player_play_anim("run_loop") # Skip run_start animation
	base.on_timeout_idle_timer = _on_timeout

func physics_update(_delta):
	if actor.is_dead:
		get_actor_statemachine().change_state(actor.die_state, prepared_message)

	print(actor.is_on_floor())

	dir = base.get_move_input()
	if not actor.ground_ray.is_colliding():
		get_actor_statemachine().change_state(actor.fly_state, prepared_message)
	if dir != 0:
		increase_speed()
		base_anim_player_resume()
		timer_started = false
		actor.flip_node.scale.x = dir
		move(dir)
		base.idle_timer.stop()
	else:
		decrease_speed_if_limit_activated()
		if not timer_started:
			timer_started = true
			await base.get_tree().process_frame
			base.idle_timer.start()
		actor.velocity.x = 0
		if base.anim_player.get_current_animation() == "run_loop":
			base_anim_player_pause()
	if Input.is_action_just_pressed("player_jump"):
		get_actor_statemachine().change_state(actor.jump_state, prepared_message)
	if Input.is_action_just_pressed("player_duck"):
		get_actor_statemachine().change_state(actor.duck_state, prepared_message)

func _on_timeout():
	get_actor_statemachine().change_state(actor.idle_state, prepared_message)
