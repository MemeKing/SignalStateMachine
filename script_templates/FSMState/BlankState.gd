class_name CHANGE_TO_NAME_OF_STATE
extends FSMState

signal fell_in_pit

func _enter_state(): pass

func _exit_state(): pass

func _physics_process(_delta: float) -> void:
	if actor.y < 0: fell_in_pit.emit()
