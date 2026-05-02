class_name CelestialWallSlide
extends FSMState

var grav

func _physics_process(delta: float) -> void:
	var side = 0
	if entity.get_last_slide_collision():
		side = entity.get_last_slide_collision().get_normal().x
	else:
		revert()
		
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

	if Input.is_action_just_pressed("jump"):
		v.x = 150 * sign(side)
		if v.y > entity.jump_velocity:
			v.y = entity.jump_velocity
		else:
			v.y += entity.jump_velocity
		
		if "dpad_nerf" in entity:
			entity.dpad_nerf = 0
		
		revert()
	
	entity.velocity = v
	entity.move_and_slide()
