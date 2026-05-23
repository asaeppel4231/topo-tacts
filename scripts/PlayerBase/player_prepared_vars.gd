extends CharacterBody2D

@onready var raycasts        = {
	"far_ground":            get_node("FarGroundRay") ,
	"ground"    : {
		"left"  :            get_node("GroundRayLeft"),
		"right":             get_node("GroundRayRight")              
	}
}

@onready var state_machine    := $StateMachine

@onready var states           = {
	"run"      :             state_machine.get_node("RunState")      ,
	"jump"     :             state_machine.get_node("JumpState")     ,
	"hit"      :             state_machine.get_node("HitState")      ,
	"knockback":             state_machine.get_node("KnockbackState"),
	"fly"      :             state_machine.get_node("FlyState")      ,
	"duck"     :             state_machine.get_node("DuckState")     ,
	"idle"     :             state_machine.get_node("IdleState")     ,
	"die"      :             state_machine.get_node("DieState")
}

@onready var player_cam       := $PlayerCamera
@onready var flip_node        := $FlipNode

@onready var models           := flip_node.get_node("Models")
@onready var hitbox           := models.get_node("Hitbox")
@onready var image            := models.get_node("Image")

@onready var hitbox_collision := $Hitbox_collision
