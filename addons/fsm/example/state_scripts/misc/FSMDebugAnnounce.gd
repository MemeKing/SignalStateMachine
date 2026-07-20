class_name FSMDebugAnnounce extends FSMState
## Just announces whether it's running or not for debug.

signal exit_state

func _enter_state() -> void:
	print("Entered debug announce state!")

func _physics_process(delta: float) -> void:
	#print("In the debug announce state!")
	if Input.is_key_pressed(KEY_Y):
		exit_state.emit()

func _exit_state() -> void:
	print("Exiting debug announce state.")
