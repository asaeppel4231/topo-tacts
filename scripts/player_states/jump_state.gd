extends HasAnimationsHelper
class_name JumpState

@export var jump_high    := 300.0
@export var max_jump_high:= 9000.0

@onready var prepared_message := {"emitted-by": "JumpState", "Reference": self}

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("JumpState entered: ", msg)
	base_anim_player_play_anim("jump")
	if msg.get("emitted-by") == "RunState":
		var speed_possible = actor.speed * -jump_high
		if speed_possible > max_jump_high:
			speed_possible = max_jump_high
		actor.velocity.y = speed_possible
	else: 
		actor.velocity.y = -jump_high
	get_actor_statemachine().change_state(actor.fly_state, {"emitted-by": "JumpState",
	"Reference": self})
