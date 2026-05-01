class_name RLJumpState
extends FSMState

var jump_speed = 500
var grav = 500
var has_jumped = false
var air_control = 10

func _exit_state():
	has_jumped = false

func _physics_process(delta: float) -> void:
	var v = actor.velocity
	
	if not has_jumped:
		has_jumped = true
		v.y = -jump_speed
	
	var direction = Input.get_axis("ui_left","ui_right")
	v.x += direction * air_control
	v.x = clamp(v.x,-actor.move_speed,actor.move_speed)
	v.y += grav * delta
	
	actor.velocity = v
	actor.move_and_slide()
	if actor.is_on_floor(): revert()
