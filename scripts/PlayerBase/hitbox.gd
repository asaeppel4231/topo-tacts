extends Area2D

@onready var hitbox_hitted := $Hitbox_hitted

func check_hitbox_hitted_exists() -> bool:
	var has_error = false
	if hitbox_hitted == null:  # alternative: if not hitbox_hitted
		push_error("[PLAYER HITBOX] Player Hitbox Hitted Node is not existent!!!")
		has_error = true
	elif hitbox_hitted is not CollisionShape2D:
		push_error("[PLAYER HITBOX] Player Hitbox Hitted Node is existent, but not a CollisionShape2D!!!")
		has_error = true
	return not has_error # alternative: return true if has_error == false else false
