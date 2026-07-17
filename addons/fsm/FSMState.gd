@abstract
class_name FSMState extends Node
## Finite State Machine state node.
##
## A state represents one discrete behavior mode (e.g., Running, Dashing, Hurt). States are activated
## and deactivated by toggling their physics_process mode. States can be reused across different 
## entities as long as the required members and methods exist. Enforcement of types is at the user's 
## discrection. [br]
## Note that _process() is NOT disabled by the fsm, and will run continuously. Useful for things like input buffers.[br]
## [br]
## [b] USAGE [/b] :[br]
## 1. Extend this class for each unique behavior [br]
## 2. Override [code]_physics_process()[/code] for behavior logic [br]
## 3. Optionally override [code]_enter_state()[/code] and [code]_exit_state()[/code] for setup/cleanup (animations, timers, etc.) [br]
## 4. Reference [code]entity[/code] for the controlled node [br] 
## [br]
## [b] TIPS [/b]:[br]
## - Remember to have balance when deciding how much a state should do.[br]
## - Override [member entity] with a type hint to get autocomplete for an intended type. [br]
## - If you emit an exit signal or [method revert], the rest of physics_process() will continue. Use [return] if that is unwanted.

## The node this state controls. Reference this to affect the entity. Example: [code]entity.velocity.x = 0[/code]
var entity : Node 
## The host FiniteStateMachine, if one exists. Otherwise state will run on it's parent. 
var fsm : FiniteStateMachine

## Called when entering this state. Use for setup code.
func _enter_state() -> void: pass

## Called when exiting this state. Use for cleanup code.
func _exit_state() -> void: pass

## Exit from this state back to default state.
func revert() -> void:
	if fsm:
		fsm.revert()


func _notification(id: int) -> void:
	match id:
		NOTIFICATION_READY:
			if not entity:
				entity = get_parent() # Will be overriden by FSM node if it exists.
		
		NOTIFICATION_PREDELETE:
			_exit_state()
