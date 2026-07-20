class_name CelestialDashState
extends FSMState

@export var speed = 400
@export var max_duration = 0.25
@export var vertical_allowed = true
@export var gravity = 0
@export var cancel_on_floor = false

var duration = 0.0
var direction = Vector2.ZERO
var target_velocity = Vector2.ZERO


func _enter_state() -> void:
	duration = 0
	entity.velocity = Vector2.ZERO
	
	direction.x = Input.get_axis("ui_left","ui_right")
	if vertical_allowed:
		direction.y = Input.get_axis("ui_up","ui_down")
		
	target_velocity = direction.normalized() * speed

	
func _physics_process(delta: float) -> void:
	entity = entity as CharacterBody2D
	
	entity.velocity = entity.velocity.move_toward(target_velocity,5000*delta)
	entity.velocity.y += gravity
	duration += delta
	if duration >= max_duration:
		fsm.change_state(fsm.default_state)

	var yv = entity.velocity.y
	entity.move_and_slide()

	#if entity.is_on_ceiling(): revert()
	if entity.is_on_wall(): 
		entity.velocity.y = speed * sign(yv)
		revert()
		
	if cancel_on_floor:
		if entity.is_on_floor(): revert()
