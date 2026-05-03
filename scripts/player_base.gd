extends Node2D

#############################################
#                   VARS                    #
#############################################

@onready var anim_player = $AnimationPlayer
@onready var player      = $Player
@onready var hitbox      = $Player/Models/Hitbox
@onready var image       = $Player/Models/Image
@onready var idle_timer  = $IdleTimer

@export var max_health: int = 100

var health: int
var is_dead: bool = false
var current_anim = ""

var is_invincible: bool = false

#############################################
#                 UTILITIES                 #
#############################################

func play_anim(name: String) -> void:
	if current_anim == name:
		return  # animation is already running
	current_anim = name # set the current animation state
	anim_player.play(name) # and play the animation

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	health = max(health, 0)
	if health == 0:
		die()

func die() -> void:
	is_dead = true
	anim_player.play("death")
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
		play_anim("run")
	else:
		if idle_timer.is_stopped():
			idle_timer.start()
	
func handle_input() -> void:
	var direction := 0

	if Input.is_action_pressed("player_left"):
		direction = -1
	elif Input.is_action_pressed("player_right"):
		direction = 1

	handle_move(direction)

	if Input.is_action_just_pressed("player_jump"):
		handle_jump()

	if Input.is_action_pressed("player_duck"):
		handle_duck()

#############################################
#             PAUSE / RESUME                #
#############################################

func pause_player() -> void:
	player.velocity = Vector2.ZERO
	set_process(false)
	set_physics_process(false)
	anim_player.pause() # pauses the animation

func resume_player() -> void:
	set_process(true)
	set_physics_process(true)
	anim_player.play() # plays the animation again, but from the current position

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	health = max_health
	
func _physics_process(_delta):
	handle_input()

#############################################
#                 EVENTS                    #
#############################################

func _on_idle_timer_timeout() -> void:
	play_anim("idle")

func _on_hitbox_body_entered(body: Node2D) -> void:
	pass

func _on_invincibly_timer_timeout() -> void:
	is_invincible = false
