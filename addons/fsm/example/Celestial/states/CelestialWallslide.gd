class_name CelestialWallSlide
extends FSMState

@export var jump_speed = -400

var jump_buffer = 0

func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		jump_buffer += delta
	else:
		jump_buffer = 0

func _physics_process(delta: float) -> void:
	print(jump_buffer)
	var side = 0
	if entity.get_last_slide_collision():
		side = entity.get_last_slide_collision().get_normal().x
	else:
		revert()
		return
		
	var v = entity.velocity
	v.x = -side * 10
	
	if v.y > 0: 
		v.y = move_toward(v.y,100,400*delta)
	else:
		v.y += entity.grav * delta
	
	if entity.is_on_floor():
		revert()
		return
	
	var direction = Input.get_axis("ui_left","ui_right")
	if direction == side:
		print("exited wallslide")
		revert()

	if jump_buffer == clamp(jump_buffer,0.001,0.04):
		v.x = 150 * sign(side)
		v.y = entity.jump_velocity
		
		if "dpad_nerf" in entity:
			entity.dpad_nerf = 0

		revert()
	
	entity.velocity = v
	entity.move_and_slide()
