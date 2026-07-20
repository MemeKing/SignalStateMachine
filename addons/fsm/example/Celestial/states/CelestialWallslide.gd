class_name CelestialWallSlide
extends FSMState

@export var jump_speed = -400.0
@export var terminal_velocity = 100.0
@export var grav = 150.0
@export var upward_friction = 100.0

var jump_buffer = 0
var jump_buffer_duration = 0.05


func _process(delta: float) -> void:
	jump_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_duration

func _physics_process(delta: float) -> void:
	var side = 0
	
	if entity.get_last_slide_collision():
		side = entity.get_last_slide_collision().get_normal().x
	else:
		revert()
		return
	
	if entity.is_on_floor():
		revert()
		return
	
	var v = entity.velocity
	v.x = -side * 120
	
	if v.y > 0: 
		v.y = move_toward(v.y,100,400*delta)
	else:
		v.y += (grav) * delta
	

	var direction = Input.get_axis("ui_left","ui_right")
	if direction == side:
		print("exited wallslide")
		revert()

	if jump_buffer > 0:
		v.x = 150 * sign(side)
		v.y = -fsm.jump_velocity
		fsm.dpad_nerf = 0.0

		if "dpad_nerf" in entity:
			entity.dpad_nerf = 0.0

		revert()

	entity.velocity = v
	entity.move_and_slide()
