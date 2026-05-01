@icon("res://addons/fsm/icon.png")
class_name SignalStateMachine extends Node
## General purpose state machine using nodes and signals.
##
## Instantiate as a child to whatever entity should be FSM controlled. FSMStates can then be
## instantiated as children of the FSM. Linking of states should be done in the parent. 
## [br][br]
## Behavior coming from the FSM does not override the actor's own physics_process().
## Any parent code will be "global" and run alongside whatever state code is running.
## [br] [br]
## See [FSMState] for more information on making states.

## The scene/entity that this FSM is controlling. Can be any [Node] type, but if a state tries to 
## access a non-existent member of [actor], a crash will occur.
@export var actor : Node

## The state the fsm is currently in. Set before FSM runs to set a default state.
## Otherwise for reference only. [br]Use [code]change_state()[/code] to force a state change.
@export var current_state: FSMState


## Set the FSM to transition to the target state whenever a signal is emitted. It's best to run this from the actor's _ready().[br][br]
## [b]Example:   [/b][code]fsm.connect(airborne_state, "touched_wall", wallslide_state)[/code]
func link(source: FSMState, exit_signal: String, target: FSMState):
	source.connect(exit_signal, Callable(self, "change_state").bind(target))

## Transition to the default state from anywhere. Using this can reduce flexibility when combining states. 
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


## Initialize children. Runs automatically when actor emits the ready 
## signal. If you add a child state during gameplay you must run this again.
func setup():
	if not actor:
		actor = get_parent()

	for child_state in get_children():
		# Add dependency injection here if needed.
		child_state.actor = actor
		child_state.set_physics_process(false)
	
	if current_state == null:
		current_state = get_child(0)
	
	change_state(current_state)
