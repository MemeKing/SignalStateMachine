class_name JDBasicState
extends FSMState

signal dashed
signal started_wallslide
signal attacked


func _physics_process(delta: float) -> void:

	var v = actor.velocity
	var grav = actor.grav
	var grounded = actor.is_on_floor()
	var direction = Input.get_axis("ui_left","ui_right")
	
	v.y += grav * delta

	if Input.is_action_just_pressed("jump") and grounded:
		v.y = -200
		
	if Input.is_action_just_released("jump") and v.y > 0:
		v.y = v.y/2
		
	if Input.is_action_just_pressed("attack") : attacked.emit()

	if direction:
		v.x = move_toward(v.x,direction*actor.speed,(1200*delta)*actor.dpad_nerf)
	else:
		v.x = move_toward(v.x,0,(1000*delta)*actor.dpad_nerf)
	
	if v.y != clamp(v.y,-200,200):
		v.y = move_toward(v.y,0,100*delta)
	
	if actor.is_on_wall() and not grounded:
		started_wallslide.emit()
	
	if Input.is_action_just_pressed("dash"): dashed.emit()
	
	actor.velocity = v
	actor.move_and_slide()
