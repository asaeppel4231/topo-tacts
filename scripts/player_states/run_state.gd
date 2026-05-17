extends HasMovementHelper
class_name RunState

var dir      := 0

var timer_started := false

@export var max_speed     := 600.0
@export var speed_increase:=   2.3
@export var default_speed := 200.0

func move(direction: int):
	actor.velocity.x = lerp(actor.velocity.x, direction * actor.speed, 0.2)

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
		return

	dir = base.get_move_input()
	if not actor.is_on_floor():
		get_actor_statemachine().change_state(actor.fly_state, {"emitted-by": "RunState", 
		"Reference": self})
	if actor.is_dead:
		get_actor_statemachine().change_state(actor.die_state, {"emitted-by": "RunState",
		"Reference": self})
	if dir != 0:
		if actor.speed < max_speed:
			actor.speed += speed_increase
		#base_anim_player_resume()
		timer_started = false
		actor.flip_node.scale.x = dir
		move(dir)
		base.idle_timer.stop()
		if Input.is_action_just_pressed("player_jump"):
			get_actor_statemachine().change_state(actor.jump_state, {"emitted-by": "RunState",
			"Reference": self})
	else:
		if actor.speed > 0:
			actor.speed -= speed_increase
		if not timer_started:
			timer_started = true
			await base.get_tree().process_frame
			base.idle_timer.start()
		actor.velocity.x = 0
		#base_anim_player_pause()

func _on_timeout():
	get_actor_statemachine().change_state(actor.idle_state, {"emitted-by": "RunState",
	"Reference": self})
