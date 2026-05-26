extends "res://scripts/PlayerBase/player_prepared_vars.gd"

@export  var player_name                  : String
@export  var max_health                   : float
@export  var invin_timer_wait_time_seconds: float

@onready var prepared_message            := {"emitted-by": "Player", "Reference": self}
@onready var speed                       := 0.0
@onready var health_manager              := HealthManagerAutoload

###########################################################
#                       UTILITIES                         #
###########################################################

func make_pcam_current() -> void:
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

###########################################################
#                   SPECIAL FUNCTIONS                     #
###########################################################

func _ready() -> void:
	await get_parent().ready
	if not check_all():
		push_error("[PLAYER] Some checks were not successful")
		return
	health_manager.register_player(player_name, max_health, max_health, invin_timer_wait_time_seconds)
	state_machine.actor = self
	state_machine.base = get_parent()

	if not is_grounded():
		state_machine.change_state(states.fly, prepared_message)
	else:
		state_machine.change_state(states.run, prepared_message)

func _exit_tree() -> void:
	health_manager.free_player(player_name)

func _physics_process(_delta) -> void: # delta is unused here
	move_and_slide()
