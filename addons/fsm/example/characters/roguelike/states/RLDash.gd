class_name RLDashState
extends FSMState

@export var speed = 800
@export var max_duration = 0.5
@export var vertical_allowed = true
@export var gravity = 0
@export var cancel_on_floor = false

var duration = 0.0
var direction = Vector2.ZERO
var target_velocity = Vector2.ZERO


func _enter_state() -> void:
	duration = 0
	actor.velocity = Vector2.ZERO
	
	direction.x = Input.get_axis("ui_left","ui_right")
	if vertical_allowed:
		direction.y = Input.get_axis("ui_up","ui_down")
		
	target_velocity = direction.normalized() * speed

	
func _physics_process(delta: float) -> void:
	actor = actor as CharacterBody2D
	
	actor.velocity = actor.velocity.move_toward(target_velocity,5000*delta)
	actor.velocity.y += gravity
	duration += delta
	if duration >= max_duration:
		revert()

	actor.move_and_slide()

	if actor.is_on_ceiling(): revert()
	if actor.is_on_wall(): revert()
		
	if cancel_on_floor:
		if actor.is_on_floor(): revert()
