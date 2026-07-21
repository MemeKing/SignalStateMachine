class_name FlippyJumpState
extends FSMState

var jump_speed = 500
var grav = 700
var has_jumped = false

func _exit_state():
	has_jumped = false
	entity.rotation = 0.0
	print("Flip exited")

func _physics_process(delta: float) -> void:
	var v = entity.velocity
	
	if not has_jumped:
		has_jumped = true
		v.y = -jump_speed

	entity.rotation += (sign(entity.velocity.x) * 20) * delta

	var direction = Input.get_axis("ui_left","ui_right")
	#v.x = move_toward(v.x,direction,100*delta)
	#v.x = clamp(v.x,-entity.speed,entity.speed)
	v.y += grav * delta

	entity.velocity = v
	entity.move_and_slide()
	if entity.is_on_floor() and v.y > 0: revert()
