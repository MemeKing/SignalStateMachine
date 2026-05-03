@icon("res://addons/fsm/microchip.svg")
class_name FiniteStateMachine extends Node
## Node-based finite state machine using signals for transitions
##
## Instantiate as a child to whatever entity should be FSM controlled. FSMStates can then be
## instantiated as children of the FSM. Linking of states should be done in the parent. 
## [br][br]
## Behavior coming from the FSM does not override the entity's script in any way.
## Any parent code will be "global" to the states and run alongside whatever state code is running.
## [br] [br] 
## See [FSMState] for more information on making states.

## The node/entity that this FSM controls. Defaults to the parent node. Can be any [Node] type, but accessing non-existent properties in [entity] will cause a crash. 
@export var entity : Node

## The state the fsm is currently in. For reference only. Use [code]change_state()[/code] to force a state change.
var current_state: FSMState


## Set the FSM to transition to the target state whenever a signal is emitted. It's best to run this from the entity's _ready().[br][br]
## [b]Example:   [/b][code]fsm.connect(airborne_state, "touched_wall", wallslide_state)[/code]
func link(source: FSMState, exit_signal: String, target: FSMState):
	source.connect(exit_signal, Callable(self, "change_state").bind(target))


## Unlink a connection you previously created with [link].
func unlink(source: FSMState,bad_signal: String,):
	source.disconnect(bad_signal, Callable(self, "change_state"))


## Transition to the default state from anywhere. Using this may reduce flexibility. 
func revert_to_default_state():
	change_state(get_child(0))


## Transition to the provided state.
func change_state(new_state: FSMState):
	if current_state is FSMState:
		current_state.set_physics_process(false)
		current_state._exit_state()

	if new_state is FSMState:
		current_state = new_state
		current_state.set_physics_process(true)
		current_state._enter_state()
	else:
		push_error(get_parent().name + "'s fsm entered invalid state." )


func _ready() -> void:
	get_parent().ready.connect(setup) 


## Initialize children. Runs automatically but waits for entity's [ready] signal. If you add or remove states during gameplay you MUST run this again.
func setup():
	if not entity:
		entity = get_parent()

	for child_state in get_children():
		# Add dependency injection here if needed.
		child_state.entity = entity
		child_state.set_physics_process(false)
	
	if current_state == null:
		current_state = get_child(0)
	
	change_state(current_state)
