class_name CelestialBasicState extends FSMState

signal dashed
signal started_wallslide
signal attacked
signal jumped

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
var grounded = false


func _process(delta: float) -> void:
	jump_buffer = move_toward(jump_buffer,0.0,delta)
	coyote_time = move_toward(coyote_time,0.0,delta)
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 0.08
	if entity.is_on_floor():
		coyote_time = 0.03


func _physics_process(delta: float) -> void:
	var v = entity.velocity
	var direction = Input.get_axis("ui_left","ui_right")
	
	if fsm and "dpad_nerf" in fsm:
		dpad_nerf = fsm.dpad_nerf

	if jump_buffer > 0 and coyote_time > 0: 
		coyote_time = 0
		fsm.jump_buffer = 0
		v.y = -jump_speed
		jumped.emit()

	if not grounded:
		v.y += grav * delta

	if Input.is_action_just_released("jump") and v.y < 0:
		v.y = v.y/2
	
	if grounded:
		if direction:
			v.x = move_toward(v.x,direction*move_speed,acceleration*delta*dpad_nerf)
		else:
			v.x = move_toward(v.x,0,friction*delta)
	
	if not grounded:
		if direction:
			v.x = move_toward(v.x,direction*move_speed,acceleration*air_control*delta*dpad_nerf)
		else:
			v.x = move_toward(v.x,0.0,air_friction*delta*dpad_nerf)
	
	if v.y > top_fall_speed:
		v.y = top_fall_speed
	
	if entity.is_on_wall() and not entity.is_on_floor():
		started_wallslide.emit()

	if Input.is_action_just_pressed("dash"): dashed.emit()
	if Input.is_action_just_pressed("attack"): attacked.emit()


	entity.velocity = v
	entity.move_and_slide()
	grounded = entity.is_on_floor()
