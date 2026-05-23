extends Node2D

@onready var anim_player := $AnimationPlayer
@onready var player      := $Player

@onready var idle_timer      := $IdleTimer
@onready var knockback_timer := $KnockbackTimer
@onready var pause_timer     := $PauseTimer
@onready var invincibly_timer := $InvinciblyTimer
