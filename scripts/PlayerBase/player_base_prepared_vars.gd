extends Node2D

@onready var anim_player := $AnimationPlayer
@onready var player      := $Player

@onready var idle_timer      := $IdleTimer
@onready var knockback_timer := $KnockbackTimer
@onready var pause_timer     := $PauseTimer
@onready var invicibly_timer := $InvinciblyTimer

@onready var on_timeout_idle_timer
@onready var on_timeout_knockback_timer
@onready var on_timeout_pause_timer
@onready var on_timeout_invincibly_timer
