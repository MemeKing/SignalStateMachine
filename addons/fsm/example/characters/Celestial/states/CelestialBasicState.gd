class_name CelestialBasicState
extends FSMState

signal dashed
signal started_wallslide
signal attacked

@export var jump_speed = -200
@export var jump_buffer_duration = 0.3
@export var coyote_time_duration = 0.3

var jump_buffer = 0.0
var coyote_time = 0.0
var has_jumped = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("jump"):
		jump_buffer += delta
	else:
		jump_buffer = 0
	
	if not entity.is_on_floor():
		coyote_time -= delta
	else:
		coyote_time = coyote_time_duration


func _physics_process(delta: float) -> void:
	var dpad_nerf = 1
	var v = entity.velocity
	var grav = entity.grav
	var grounded = entity.is_on_floor()
	var direction = Input.get_axis("ui_left","ui_right")
	
	if "dpad_nerf" in entity: dpad_nerf = entity.dpad_nerf

	if jump_buffer == clamp(jump_buffer,0.0001,0.3) and coyote_time > 0: 
		v.y = jump_speed
		coyote_time = 0
	
	v.y += grav * delta

	if Input.is_action_just_released("jump") and v.y < 0:
		v.y = v.y/2
	
	if Input.is_action_just_pressed("attack"): 
		attacked.emit()

	if direction:
		v.x = move_toward(v.x,direction*entity.speed,(1200*delta)*dpad_nerf)
	else:
		v.x = move_toward(v.x,0,(1000*delta)*dpad_nerf)
	
	if v.y > clamp(v.y,-300,300):
		v.y = move_toward(v.y,0,100*delta)
	
	if entity.is_on_wall() and not entity.is_on_floor():
		started_wallslide.emit()
	
	if Input.is_action_just_pressed("dash"): dashed.emit()

	entity.velocity = v
	entity.move_and_slide()
