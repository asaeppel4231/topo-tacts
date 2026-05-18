extends HasAnimationsHelper
class_name JumpState

@export var jump_high    := 300.0
@export var jump_divider := 0.01

@onready var prepared_message := {"emitted-by": "JumpState", "Reference": self}

func enter(msg := {}):
	if UserData.get_value("debug") == 1:
		print("JumpState entered: ", msg)
	base_anim_player_play_anim("jump")
	if msg.get("emitted-by") == "RunState":
		#actor.velocity.y = -jump_high * jump_divider * actor.speed Jumps to high
		actor.velocity.y = -jump_high
	else: 
		actor.velocity.y = -jump_high
	get_actor_statemachine().change_state(actor.fly_state, {"emitted-by": "JumpState",
	"Reference": self})
