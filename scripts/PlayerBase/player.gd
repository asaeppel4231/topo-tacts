extends CharacterBody2D

@onready var far_ground_ray   := $FarGroundRay
@onready var ground_ray_left  := $GroundRayLeft
@onready var ground_ray_right := $GroundRayRight
@onready var player_cam       := $PlayerCamera
@onready var flip_node        := $FlipNode
@onready var models           := $FlipNode/Models
@onready var hitbox           := $FlipNode/Models/Hitbox
@onready var image            := $FlipNode/Models/Image
@onready var state_machine    := $StateMachine
@onready var hitbox_collision := $Hitbox_collision

@onready var run_state  := $StateMachine/RunState
@onready var jump_state := $StateMachine/JumpState
@onready var fly_state  := $StateMachine/FlyState
@onready var duck_state := $StateMachine/DuckState
@onready var idle_state := $StateMachine/IdleState
@onready var die_state  := $StateMachine/DieState

@export var max_health: int = 100

var health: int
var is_dead: bool = false
var is_invincible: bool = false

var knockback_velocity := Vector2.ZERO
var knockback_time     := 0.0

var speed              := 0.0

#############################################
#                 UTILITIES                 #
#############################################

func make_pcam_current():
	player_cam.make_current()

func take_damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	health = max(health, 0)
	if health == 0:
		die()

func die() -> void:
	is_dead = true
	get_parent().anim_player.stop()

func apply_damage(event: DamageEvent) -> void:
	if event.direct_die:
		health = 0
	if is_invincible or is_dead:
		return
	take_damage(event.amount)
	# Knockback an Player weitergeben
	apply_knockback(event.knockback)

func jump():
	pass

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force
	knockback_time = 0.15   # Time of the Knockback

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready():
	await get_parent().ready

	state_machine.actor = self
	state_machine.base = get_parent()

	if not is_on_floor():
		state_machine.change_state(fly_state, {"emitted-by": "Player (_ready)", "Reference": self})
	else:
		state_machine.change_state(run_state, {"emitted-by": "Player (_ready)", "Reference": self})

func _process(_delta: float) -> void:
	pass

func _physics_process(delta):
	# Knockback
	if knockback_time > 0:
		velocity = knockback_velocity
		knockback_time -= delta
	move_and_slide()
