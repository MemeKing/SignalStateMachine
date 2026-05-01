class_name RLDummy
extends FSMState

func _enter_state():
	revert()

func _physics_process(delta: float) -> void:
	print("Empty.")
