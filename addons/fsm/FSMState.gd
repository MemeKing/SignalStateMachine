@abstract
class_name FSMState extends Node
## Finite State Machine state node.
##
## A state represents one discrete behavior mode (e.g., Running, Dashing, Stunned). They are 
## activated and deactivated by toggling their physics_process mode. State nodes can be reused 
## across different entities, provided the required members exist. Note that _process() is NOT 
## disabled by the fsm, and will run continuously.
## [br][br]
## [b] TIPS [/b]:[br]
## - Self-assign [member entity] with a type hint to get autocomplete for an intended type. [br]
## - If you emit an exit signal or [method revert], the rest of physics_process() will continue. Use [return] if that is unwanted.

var entity : Node ## The node this state controls. Reference this to affect the entity. Example: [code]entity.velocity.x = 0[/code]
var fsm : FiniteStateMachine ## The host FiniteStateMachine, if one exists. Otherwise state will run on it's parent.


## Called when entering this state. Use for setup code.
func _enter_state() -> void: pass


## Called when exiting this state. Use for cleanup code.
func _exit_state() -> void: pass


## Revert the fsm back to the default state without using a link.
func revert() -> void:
	if not fsm: return
	fsm.change_state(fsm.default_state)
