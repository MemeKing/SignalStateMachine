class_name FSMDummyState extends FSMState
## Literally just exits itself immediately. Use if something like an "ability slot" can't be null.

func _enter_state():
	revert()
