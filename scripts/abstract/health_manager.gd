extends Node
class_name HealthManager

signal GameOver(player_name)

@onready var players := {}

func register_player(player_name: StringName, max_health: float, health: float, invincible_wait_time: float) -> void:
	players[player_name] = {
		"max_health": max_health,
		"health": health,
		"invincible": false,
		"invincible_wait_time": invincible_wait_time,
		"timer": null
	}

func free_player(player_name: StringName) -> void:
	if players[player_name]["timer"] != null: # you can leave != null out of this line
		players[player_name]["timer"].queue_free()
	players.erase(player_name)

func apply_damage(player_name: StringName, direct_die: bool, amount: float) -> void:
	var p = players[player_name]
	if p["invincible"]:
		return
	
	if direct_die:
		p["health"] = 0
	p["health"] -=  amount
	
	if p["health"] <= 0:
		emit_signal("GameOver", player_name)
		return

	p["invincible"] = true
	
	if p["timer"] == null:
		var timer := Timer.new()
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(_on_timeout.bind(player_name))
		p["timer"] = timer
	p["timer"].start(p["invincible_wait_time"])

func _on_timeout(player_name: StringName) -> void:
	players[player_name]["invincible"] = false
