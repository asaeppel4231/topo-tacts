extends "res://scripts/PlayerBase/player_prepared_vars.gd"

var is_invincible: bool = false

var speed              := 0.0

@onready var prepared_message := {"emitted-by": "Player", "Reference": self}

#############################################
#                 UTILITIES                 #
#############################################

func make_pcam_current():
	player_cam.make_current()

func apply_damage(event: DamageEvent) -> void:
	var temp := prepared_message
	temp.amount     = event.amount
	temp.type       = event.type
	temp.source     = event.source
	temp.knockback  = event.knockback
	temp.direct_die = event.direct_die
	temp.state_before = state_machine.current_state
	state_machine.change_state(states.hit, temp)

func is_grounded() -> bool:
	return raycasts.ground.left.is_colliding() or raycasts.ground.right.is_colliding()

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready():
	await get_parent().ready

	state_machine.actor = self
	state_machine.base = get_parent()

	if not is_grounded():
		state_machine.change_state(states.fly, prepared_message)
	else:
		state_machine.change_state(states.run, prepared_message)

func _physics_process(_delta): # delta is unused here
	move_and_slide()
