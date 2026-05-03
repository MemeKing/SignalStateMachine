class_name RLBasicState
extends FSMState

@export var grav = 500

signal do_action_1
signal do_action_2


	
func _physics_process(delta: float) -> void:
	entity.rotation = rotate_toward(entity.rotation,0,delta)
	var v = entity.velocity
	var grounded = entity.is_on_floor()
	var direction = Input.get_axis("ui_left", "ui_right")
	

	v.x = sign(direction) * entity.move_speed
	
	if not grounded: v.y += grav * delta

	if Input.is_key_pressed(KEY_Z): do_action_1.emit()
	if Input.is_key_pressed(KEY_X): do_action_2.emit()


	
	entity.velocity = v
	entity.move_and_slide()
