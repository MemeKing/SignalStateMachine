@icon("res://addons/fsm/icons/cpu.svg")
class_name FiniteStateMachine extends Node
## Node-based finite state machine using signals
##
## Instantiate [FSMState]s as children. Child States can use [code]entity.property[/code] to effect 
## the target [member entity]. Upon receiving an exit signal from any state, the FSM will queue a 
## transition to whatever state it has been linked to, if any. States can be mixed and matched to
## create complex behaviors from a collection of simple and discrete states. 

signal state_changed(new_state:FSMState,old_state:FSMState) ## Emits when a state changes successfully. 

@export var entity : Node            ## What this FSM controls. Defaults to the parent node. Can be any [Node] type, but accessing non-existent members will cause a crash. 
@export var default_state: FSMState  ## The state the FSM starts in. Defaults to 1st valid child.
var current_state: FSMState          ## The state that is currently active. Use [method change_state] rather than setting this directly.
var connections : Dictionary = {}    ## Dictionary storing connections from [method link]. 

## Link a state's exit signal to another state, causing a transition every time the signal is received.
func link(exit_signal: Signal, target_state: FSMState) -> void:
	var transition_callable = Callable(self, "change_state").bind(target_state)
	connections[exit_signal] = transition_callable
	exit_signal.connect(transition_callable)

## Unlink a signal that was previously linked. 
func unlink(exit_signal: Signal) -> void:
	if connections.has(exit_signal):
		exit_signal.disconnect(connections[exit_signal])
		connections.erase(exit_signal)


## Runs when [member entity] has emitted it's [member Node.ready] signal, meaning all it's child nodes are ready. [method setup] will still run automatically if you override this.
func _deferred_ready() -> void: 
	pass


## Transition the FSM back to [member default_state].
func revert() -> void:
	change_state(default_state)


## Queue a transition to [code]new_state[/code] for the end of the frame.
func change_state(new_state: FSMState) -> void:
	call_deferred("change_state_now",new_state)


## Perform an immediate state transition. Normally called internally by change_state(). 
func change_state_now(new_state: FSMState) -> void:
	if current_state and current_state is FSMState:
		current_state.set_physics_process(false)
		current_state._exit_state()
	
	state_changed.emit(new_state,current_state)
	current_state = new_state
	current_state._enter_state()
	current_state.set_physics_process(true)


## Initialize the FSM. Runs automatically at start, and with [method deploy_state], but you may need 
## to run this if doing fancy manual state manipulation during gameplay.
func setup() -> void:
	entity = get_parent() if not entity else entity
	var child_states = find_children("*","FSMState",true,false)
	for state in child_states:
		state.entity = entity
		state.fsm = self
		state.set_physics_process(false)
	if not default_state:
		default_state = child_states[0]


## Give this FSM a new state during gameplay. FSM will add new_state to children and run initialization.
func deploy_state(state: FSMState) -> void:
	add_child(state)
	setup()

## Remove a state and all it's connections.
func delete_state(state: FSMState) -> void:
	state.queue_free()
	var to_remove: Array[Signal] = []
	for sig: Signal in connections.keys():
		if sig.get_object() == state:
			to_remove.append(sig)
	for bad_signal in to_remove:
		unlink(bad_signal)


func _notification(id: int) -> void:
	if id == NOTIFICATION_READY:
		entity = entity if entity else get_parent()
		await entity.ready
		_deferred_ready()
		setup()
		change_state(default_state)
