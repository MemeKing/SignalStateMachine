class_name CelestialBasicState extends FSMState

signal dashed
signal started_wallslide
signal attacked
signal jumped
signal double_jumped

@export var jump_speed = 390
@export var move_speed = 250
@export var grav = 900
@export var acceleration = 7000
@export var friction = 5000
@export var air_friction = 200
@export var air_control = 1.0
@export var top_fall_speed = 300
var dpad_nerf = 1.0
var jump_buffer = 0.0
var coyote_time = 0.0
var can_dash = false
var grounded = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0.08
	else:
		jump_buffer = move_toward(jump_buffer,0.0,delta)

	if entity.is_on_floor():
		coyote_time = 0.03
	else:
		coyote_time = move_toward(coyote_time,0.0,delta)


func _physics_process(delta: float) -> void:
	var v = entity.velocity
	var direction = Input.get_axis("ui_left","ui_right")
	
	if "dpad_nerf" in entity:
		dpad_nerf = entity.dpad_nerf
	
	if "jump_buffer" in entity:
		jump_buffer = entity.jump_buffer
		
	if "can_dash" in entity:
		can_dash = entity.can_dash

	if jump_buffer > 0 and coyote_time > 0: 
		coyote_time = 0
		v.y = -jump_speed
		jumped.emit()
		jump_buffer = 0
		if "jump_buffer" in entity:
			entity.jump_buffer = 0
		

	if not grounded:
		v.y += grav * delta

	if Input.is_action_just_released("jump") and v.y < 0:
		v.y = v.y/2
	
	if grounded:
		can_dash = true
		if direction:
			v.x = move_toward(v.x,direction*move_speed,acceleration*delta*dpad_nerf)
		else:
			v.x = move_toward(v.x,0,friction*delta)
	
	if not grounded:
		if direction:
			v.x = move_toward(v.x,direction*move_speed,acceleration*air_control*delta*dpad_nerf)
		else:
			v.x = move_toward(v.x,0.0,air_friction*delta*dpad_nerf)
	
	if not grounded and jump_buffer > 0:
		double_jumped.emit()
	
	if v.y > top_fall_speed:
		v.y = top_fall_speed
	
	if entity.is_on_wall() and not entity.is_on_floor():
		started_wallslide.emit()

	if Input.is_action_just_pressed("dash") and can_dash: 
		dashed.emit()
		can_dash = false
		if "can_dash" in entity:
			entity.can_dash = false
	if Input.is_action_just_pressed("attack"): attacked.emit()


	entity.velocity = v
	entity.move_and_slide()
	grounded = entity.is_on_floor()
