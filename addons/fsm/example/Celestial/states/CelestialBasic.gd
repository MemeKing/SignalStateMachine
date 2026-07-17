class_name CelestialBasicState extends FSMState
## Player Controller similar to "Celeste"

signal dashed
signal started_wallslide
signal attacked
signal jumped

@export var jump_speed = 0
@export var move_speed = 100
@export var grav = 300
@export var acceleration = 1000
@export var friction = 1000
@export var air_control = 1000
@export var top_fall_speed = 100
@export var jump_buffer_duration = 0.3
@export var coyote_time_duration = 0.3

var jump_buffer = 0.0
var coyote_time = 0.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer = jump_buffer_duration

	if entity.is_on_floor():
		coyote_time = coyote_time_duration
	else:
		coyote_time -= delta


func _physics_process(delta: float) -> void:
	var dpad_nerf = 1
	var v = entity.velocity
	var grounded = entity.is_on_floor()
	var direction = Input.get_axis("ui_left","ui_right")
	
	if "dpad_nerf" in entity: dpad_nerf = entity.dpad_nerf

	if jump_buffer > 0 and jump_buffer < jump_buffer_duration and coyote_time > 0: 
		coyote_time = 0
		v.y = -jump_speed
		jumped.emit()
	
	if not grounded:
		v.y += grav * delta

	if Input.is_action_just_released("jump") and v.y < 0:
		v.y = v.y/2
	
	if grounded:
		if direction:
			v.x = move_toward(v.x,direction*move_speed*dpad_nerf,acceleration*delta)
			if sign(direction) != sign(v.x):
				v.x = move_toward(v.x,direction*move_speed*dpad_nerf,acceleration*delta)
		else:
			v.x = move_toward(v.x,0,friction*delta)
	
	if not grounded:
		if direction:
			v.x = move_toward(v.x,direction*move_speed*dpad_nerf,air_control*delta)
	
	if v.y > top_fall_speed:
		v.y = top_fall_speed
	
	if entity.is_on_wall() and not entity.is_on_floor():
		started_wallslide.emit()
	
	if Input.is_action_just_pressed("dash"): dashed.emit()
	if Input.is_action_just_pressed("attack"): attacked.emit()
	
	jump_buffer -= delta

	entity.velocity = v
	entity.move_and_slide()
