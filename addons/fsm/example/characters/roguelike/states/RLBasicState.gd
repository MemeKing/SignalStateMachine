class_name RLBasicState
extends FSMState

@export var grav = 500

signal do_action_1
signal do_action_2

func _physics_process(delta: float) -> void:
	actor.rotation = rotate_toward(actor.rotation,0,delta)
	var v = actor.velocity
	var grounded = actor.is_on_floor()
	var direction = Input.get_axis("ui_left", "ui_right")
	

	v.x = sign(direction) * actor.move_speed
	
	if not grounded: v.y += grav * delta

	if Input.is_key_pressed(KEY_Z): do_action_1.emit()
	if Input.is_key_pressed(KEY_X): do_action_2.emit()


	
	actor.velocity = v
	actor.move_and_slide()
