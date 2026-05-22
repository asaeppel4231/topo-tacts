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
	state_machine.change_state(hit_state, temp)
	
#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready():
	await get_parent().ready

	state_machine.actor = self
	state_machine.base = get_parent()

	if not is_on_floor():
		state_machine.change_state(fly_state, prepared_message)
	else:
		state_machine.change_state(run_state, prepared_message)

func _physics_process(delta):
	move_and_slide()
