class_name YesclipState
extends FSMState

signal exited

@export var acceleration = 50
@export var friction = 10

func _ready() -> void: pass 

func _exit_state():
	entity.rotation = 0

func _physics_process(delta: float) -> void:
	var v = entity.velocity
	var x = Input.get_axis("ui_left","ui_right")
	var y = Input.get_axis("ui_up","ui_down")
	var axis = Vector2(x,y)
	
	if axis.length() > 0:
		v += (axis * acceleration) * delta
	else:
		v = v.move_toward(Vector2.ZERO,friction*delta)
	
	if Input.is_action_just_pressed("jump"):
		revert()
	
	entity.rotate(delta)
	
	entity.velocity = v
	entity.move_and_slide()
