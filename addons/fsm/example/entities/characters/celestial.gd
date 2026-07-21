extends CharacterBody2D

var jump_buffer = 0.0
var grounded = false
var dpad_nerf = 1.0
var can_dash = true

@onready var fsm = $FiniteStateMachine
@onready var basic = $FiniteStateMachine/CelestialBasicState
@onready var wallslide = $FiniteStateMachine/CelestialWallSlide
@onready var dash = $FiniteStateMachine/CelestialDashState

func _ready() -> void:
	fsm.link_add(basic.dashed,dash)
	fsm.link_add(basic.started_wallslide,wallslide)

func _process(delta: float) -> void:
	dpad_nerf = move_toward(dpad_nerf,1.0,delta/2)
	jump_buffer = move_toward(jump_buffer,0.0,delta)
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0.06
	if is_on_floor():
		can_dash = true
