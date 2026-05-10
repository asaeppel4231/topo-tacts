extends Node2D

#############################################
#                   VARS                    #
#############################################

@onready var anim_player = $AnimationPlayer
@onready var player      = $Player
@onready var hitbox      = $Player/Models/Hitbox
@onready var image       = $Player/Models/Image
@onready var idle_timer  = $IdleTimer

@onready var state_machine = $Player/StateMachine

@export var idle_state: State
@export var run_state: State
@export var jump_state: State
@export var duck_state: State
@export var hurt_state: State
@export var dead_state: State

@export var max_health: int = 100

var health: int
var is_dead: bool = false
var is_invincible: bool = false

var current_anim = ""
var last_anim    = ""

var is_paused: bool = false

#############################################
#                 UTILITIES                 #
#############################################

func play_anim(animation_name: String) -> void:
	if current_anim == animation_name:
		return  # animation is already running
	last_anim = current_anim
	current_anim = animation_name # set the current animation state
	anim_player.play(animation_name) # and play the animation

func unduck():
	anim_player.play("unduck")

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	health = max(health, 0)
	if health == 0:
		die()

func die() -> void:
	is_dead = true
	play_anim("death")
	set_process(false)           # freeze's this script
	set_physics_process(false)   # freeze's this script

func apply_damage(event: DamageEvent) -> void:
	if is_invincible or is_dead:
		return
	take_damage(event.amount)
	# Knockback an Player weitergeben
	player.apply_knockback(event.knockback)

#############################################
#             INPUT HANDLING                #
#############################################

func handle_jump() -> void:
	player.jump()
	play_anim("jump")

func handle_duck() -> void:
	play_anim("duck")

func handle_move(direction: int) -> void:
	player.move(direction)
	if direction != 0:
		idle_timer.stop()
		image.flip_h = direction < 0
		play_anim("run_start")
		play_anim("run_loop")
	else:
		if idle_timer.is_stopped():
			idle_timer.start()
	
func handle_input() -> void:
	var direction = 0

	if Input.is_action_pressed("player_left"):
		direction = -1
	elif Input.is_action_pressed("player_right"):
		direction = 1

	handle_move(direction)

	if Input.is_action_just_pressed("player_jump"):
		state_machine.change_state(jump_state)

	if Input.is_action_pressed("player_duck"):
		handle_duck()

func get_move_input() -> int:
	var dir = 0
	if Input.is_action_pressed("player_left"):
		dir = -1
	elif Input.is_action_pressed("player_right"):
		dir = 1
	return dir
	
#############################################
#             PAUSE / RESUME                #
#############################################

func pause_player():
	is_paused = true
	anim_player.pause()
	player.velocity = Vector2.ZERO

func resume_player():
	is_paused = false
	anim_player.play()

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	health = max_health
	state_machine.owner = self
	state_machine.change_state(idle_state)
	
func _physics_process(_delta):
	handle_input()

#############################################
#                 EVENTS                    #
#############################################

func _on_idle_timer_timeout():
	if not is_dead and not Input.is_action_pressed("player_duck") and player.is_on_floor():
		play_anim("idle")

func _on_hitbox_body_entered(_body: Node2D) -> void: # body is unused here
	pass

func _on_invincibly_timer_timeout() -> void:
	is_invincible = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void: # anim_name is unused here
	print("Animation player finished...")
		# Jetzt entscheiden, was danach passieren soll
	if abs(player.velocity.x) > 2:
	#		play_anim("run")
		pass
	else:
		play_anim("idle")
