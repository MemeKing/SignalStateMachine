class_name ExampleNoclipState
extends FSMState

signal exited_noclip

@export var acceleration = 10
@export var friction = 10

func _ready() -> void: pass 

func _enter_state():
	entity.hitbox.disabled = true

func _exit_state():
	entity.hitbox.disabled = false
	entity.rotation = 0
	print("Exited.")

func _physics_process(delta: float) -> void:
	print("I ran!")
	var v = entity.velocity as Vector2
	var x = Input.get_axis("ui_left","ui_right")
	var y = Input.get_axis("ui_up","ui_down")
	var axis = Vector2(x,y)
	
	if axis.length() > 0:
		v += (axis * acceleration) * delta
	else:
		v = v.move_toward(Vector2.ZERO,friction*delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		exited_noclip.emit()
	
	entity.rotate(delta)
	
	entity.velocity = v
	entity.move_and_slide()
