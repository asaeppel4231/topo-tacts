extends Node2D

#############################################
#                   VARS                    #
#############################################

@onready var anim_player := $AnimationPlayer
@onready var player      := $Player

@onready var idle_timer      := $IdleTimer
@onready var knockback_timer := $KnockbackTimer
@onready var pause_timer := $PauseTimer
@onready var invicibly_timer := $InvinciblyTimer

var is_paused    := true

@onready var on_timeout_idle_timer
@onready var on_timeout_knockback_timer
@onready var on_timeout_pause_timer
@onready var on_timeout_invincibly_timer

#############################################
#             INPUT HANDLING                #
#############################################

func get_move_input() -> int:
	var dir = 0
	if Input.is_action_pressed("player_left"):
		dir = -1
	elif Input.is_action_pressed("player_right"):
		dir = 1
	return dir

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	pass
	
func _process(_delta):
	pass

#############################################
#                 EVENTS                    #
#############################################

func _on_idle_timer_timeout():
	on_timeout_idle_timer.call()

func _on_invincibly_timer_timeout() -> void:
	on_timeout_invincibly_timer.call()

func _on_knockback_timer_timeout() -> void:
	on_timeout_knockback_timer.call()

func _on_pause_timer_timeout() -> void:
	on_timeout_pause_timer.call()

func _on_hitbox_body_entered(_body: Node2D) -> void: # body is unused here
	pass
