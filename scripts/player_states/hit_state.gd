extends    IsPlayerState
class_name HitState

@onready var is_gameover := false
@onready var prepared_message := {"emitted-by": "HitState", "Reference": self}

func _ready() -> void:
	is_gameover = false

func enter(msg := {}) -> void:
	if UserData.get_value("debug") == 1:
		print("HitState entered: ", msg)
	base_anim_player_stop()
	connect_signal(actor.health_manager.GameOver, _on_game_over)
	actor.health_manager.apply_damage(actor.player_name, msg.direct_die, msg.amount)

	var temp := prepared_message.duplicate(true)
	temp.knockback = msg.knockback

	if not is_gameover:
		base_anim_player_play_anim("Triax/hit")
		get_actor_statemachine().change_state(actor.states.knockback, temp)

func _on_game_over(player_name: StringName) -> void:
	if player_name == actor.player_name:
		is_gameover = true
		get_actor_statemachine().change_state(actor.states.die, prepared_message)
