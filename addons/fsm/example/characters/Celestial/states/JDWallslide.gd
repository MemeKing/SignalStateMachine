class_name JDWallslide
extends FSMState

var cooldown = 1

func _physics_process(delta: float) -> void:
	var side = 0
	if actor.get_last_slide_collision():
		side = actor.get_last_slide_collision().get_normal().x
	else:
		revert()
	var v = actor.velocity
	actor.velocity.x = -side
	
	if v.y > 0: 
		v.y = move_toward(v.y,100,400*delta)
	else:
		v.y += actor.grav * delta
	
	if actor.is_on_floor():
		revert()
		return

	if Input.is_action_just_pressed("ui_accept"):
		v.x = 150 * sign(side)
		if v.y > actor.jump_velocity:
			v.y = actor.jump_velocity
		else:
			v.y += actor.jump_velocity
		actor.dpad_nerf = 0
		revert()
	
	actor.velocity = v
	actor.move_and_slide()
