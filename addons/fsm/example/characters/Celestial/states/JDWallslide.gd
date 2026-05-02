class_name JDWallslide
extends FSMState

var cooldown = 1

func _physics_process(delta: float) -> void:
	var side = 0
	if entity.get_last_slide_collision():
		side = entity.get_last_slide_collision().get_normal().x
	else:
		revert()
	var v = entity.velocity
	entity.velocity.x = -side
	
	if v.y > 0: 
		v.y = move_toward(v.y,100,400*delta)
	else:
		v.y += entity.grav * delta
	
	if entity.is_on_floor():
		revert()
		return

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
