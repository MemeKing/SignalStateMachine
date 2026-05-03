class_name FSMDummyState extends FSMState
## Literally just exits immediately. 

func _enter_state():
	revert()
