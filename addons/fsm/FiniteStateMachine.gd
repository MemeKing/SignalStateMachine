@icon("res://addons/fsm/cpu.svg")
class_name FiniteStateMachine extends Node
## Node-based finite state machine using signals for transitions
##
## Instantiate [FSMState]s as children. Use [method link] to connect states, either in the target 
## entity's script or an extended FSM script. 
## [br][br]
## All FSM code runs alongside the entity's own script rather than replacing it. Upon receiving an 
## exit signal from any state, a transition will be queued for the end of the current frame.[br][br]
## The state's [method _physics_process] will NOT run again if an exit has been requested, but 
## [method _physics_process()] will continue to the end unless you [code]return[/code].

signal state_changed(new_state:FSMState,old_state:FSMState) ## Emits when a state changes successfully. 

@export var entity : Node            ## What this FSM controls. Defaults to the parent node. Can be any [Node] type, but accessing non-existent properties will cause a crash. 
@export var default_state: FSMState  ## The state the FSM starts in. Defaults to 1st child.
var current_state: FSMState          ## The state the FSM is currently in. Use [code]change_state()[/code] rather than setting this directly.
var connections = {}

## Link a state's exit signal to another state, causing a transition every time the signal is fired. [br]
## [b]Example:   [/b][code]fsm.connect(airborne_state, "touched_wall", wallslide_state)[/code]
func link(exit_signal: Signal, target_state: FSMState):
	var transition_callable = Callable(self, "change_state").bind(target_state)
	connections[exit_signal] = transition_callable
	exit_signal.connect(transition_callable)

## Unlink a state connection that was previously linked. 
func unlink(exit_signal: Signal):
	if connections.has(exit_signal):
		exit_signal.disconnect(connections[exit_signal])
		connections.erase(exit_signal)


## Runs when [member entity] has emitted it's [member Node.ready] signal, meaning all it's child nodes are ready.
## Inject special state dependencies here. 
func _entity_ready() -> void: pass

## Transition the FSM back to [member default_state].
func revert() -> void:
	if default_state:
		change_state(default_state)
	else:
		change_state(get_child(0))


## Queues a transition to [code]new_state[/code] which occurs after the current physics frame is finished.
func change_state(new_state: FSMState) -> void:
	call_deferred("change_state_now",new_state)

## Perform an immediate state transition. Normally called internally by change_state(). 
func change_state_now(new_state: FSMState) -> void:
	if current_state is FSMState:
		current_state.set_physics_process(false)
		current_state._exit_state()

	if new_state is FSMState:
		state_changed.emit(new_state,current_state)
		current_state = new_state
		current_state._enter_state()
		current_state.set_physics_process(true)
	else:
		push_error( entity.name + "'s fsm entered invalid state." )


## Initialize the FSM. Runs automatically, but if you add or remove states during gameplay you MUST run this again.
func setup():
	if not entity:
		entity = get_parent()
	if not default_state:
		default_state = get_child(0)
	for child: FSMState in get_children():
		child.entity = entity
		child.fsm = self
		child.set_physics_process(false)

	change_state(default_state)


func _notification(id: int) -> void:
	if id == NOTIFICATION_READY:
		entity = entity if entity else get_parent()
		await entity.ready
		setup()
