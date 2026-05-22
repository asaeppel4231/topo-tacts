extends CharacterBody2D

@onready var far_ground_ray   := $FarGroundRay
@onready var ground_ray_left  := $GroundRayLeft
@onready var ground_ray_right := $GroundRayRight
@onready var player_cam       := $PlayerCamera
@onready var flip_node        := $FlipNode
@onready var models           := $FlipNode/Models
@onready var hitbox           := $FlipNode/Models/Hitbox
@onready var image            := $FlipNode/Models/Image
@onready var state_machine    := $StateMachine
@onready var hitbox_collision := $Hitbox_collision

@onready var run_state  := $StateMachine/RunState
@onready var jump_state := $StateMachine/JumpState
@onready var hit_state := $StateMachine/HitState
@onready var fly_state  := $StateMachine/FlyState
@onready var duck_state := $StateMachine/DuckState
@onready var idle_state := $StateMachine/IdleState
@onready var die_state  := $StateMachine/DieState
