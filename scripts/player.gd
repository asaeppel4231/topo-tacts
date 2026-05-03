extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 350.0
@export var gravity: float = 900.0

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_time              = 0.0

func move(direction: int):
	velocity.x = lerp(velocity.x, direction * speed, 0.2)

func jump():
	if is_on_floor():
		velocity.y = -jump_force

func apply_damage(event: DamageEvent) -> void:
	get_parent().apply_damage(event)

func apply_knockback(force: Vector2) -> void:
	knockback_velocity = force
	knockback_time = 0.15   # Time of the Knockback

func _physics_process(delta):
	if knockback_time > 0:
		velocity = knockback_velocity
		knockback_time -= delta
	# Gravitation
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
