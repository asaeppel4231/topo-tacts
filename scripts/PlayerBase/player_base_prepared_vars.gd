extends Node2D

@onready var anim_player := $AnimationPlayer
@onready var player      := $Player

@onready var timers := {
	"idle"     : $IdleTimer,
	"knockback": $KnockbackTimer
}

func check_anim_player_exists() -> bool:
	var has_error = false
	if anim_player == null: # alternative: if not anim_player
		push_error("[PREPARED VARS FOR PLAYERBASE] Animation Player Node is not existent!!!")
		has_error = true
	elif anim_player is not AnimationPlayer:
		push_error("[PREPARED VARS FOR PLAYERBASE] Animation Player Node is existent, but not an AnimationPlayer!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_player_exists() -> bool:
	var has_error = false
	if player == null: # alternative: if not player
		push_error("[PREPARED VARS FOR PLAYERBASE] Player Node is not existent!!!")
		has_error = true
	elif player is not CharacterBody2D:
		push_error("[PREPARED VARS FOR PLAYERBASE] Player Node is existent, but not a CharacterBody2D!!!")
		has_error = true
	elif player.get_script() != preload("res://scripts/PlayerBase/player.gd"):
		push_error("[PREPARED VARS FOR PLAYERBASE] Player Node is existent, but has a wrong script path!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_timers_exists() -> bool:
	var has_error = false
	if timers == null: # alternative: if not timers, same pattern for following if checks
		push_error("[PREPARED VARS FOR PLAYERBASE] Timers dictionary is null!!!")
		has_error = true
	else:
		if timers.idle == null:
			push_error("[PREPARED VARS FOR PLAYERBASE] Idle Timer Node is not existent!!!")
			has_error = true
		elif timers.idle is not Timer:
			push_error("[PREPARED VARS FOR PLAYERBASE] Idle Timer Node is existent, but not a Timer!!!")
			has_error = true
		if timers.knockback == null:
			push_error("[PREPARED VARS FOR PLAYERBASE] Knockback Timer Node is not existent!!!")
			has_error = true
		elif timers.knockback is not Timer:
			push_error("[PREPARED VARS FOR PLAYERBASE] Knockback Timer Node is existent, but not a Timer!!!")
			has_error = true
	return not has_error # alternative: return true if has_error == false else false

func check_all() -> bool:
	return check_anim_player_exists() and check_player_exists() and check_timers_exists()
