class_name RLFlippyJump
extends FSMState

var jump_speed = 500
var grav = 700
var has_jumped = false

func _exit_state():
	has_jumped = false
	actor.rotation = false

func _physics_process(delta: float) -> void:
	var v = actor.velocity
	
	if not has_jumped:
		has_jumped = true
		v.y = -jump_speed

	actor.rotation += (sign(actor.velocity.x) * 20) * delta

	var direction = Input.get_axis("ui_left","ui_right")
	#v.x = move_toward(v.x,direction,100*delta)
	v.x = clamp(v.x,-actor.speed,actor.speed)
	v.y += grav * delta

	actor.velocity = v
	actor.move_and_slide()
	if actor.is_on_floor() and v.y > 0: revert()
