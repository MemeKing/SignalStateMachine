@abstract
class_name FSMState extends Node
## Finite State Machine state node.
##
## A state represents one discrete behavior mode (e.g., Running, Dashing, Hurt). States are 
## activated/deactivated by toggling their physics_process mode, which makes overlaps impossible. [br]
## Note that _process() is NOT disabled by the fsm, and will run continuously. Useful for things like jump buffers.[br]
## States can be reused across different entitys as long as the required properties exist. 
## Enforcement of types is at the user's discrection. [br] 

## [br][br]
## Usage :[br]
## 1. Extend this class for each unique behavior [br]
## 2. Override [_physics_process] for behavior logic [br]
## 3. Override [_enter_state()]/[_exit_state] for setup/cleanup (animations, timers, etc.) [br]
## 4. Reference [entity] for the controlled node [br] [br]
##
## Use [_enter_state] and [_exit_state] for setup and cleanup logic such as initializing variables, starting timers, or resetting values. [br][br]
## 
## Remember to have balance when creating states. Like in all things, highly complex behavior can 
## arise from simplicity. But not every little movement  needs to be a state of it's own. 
## Also, states don't need to be guaranteed to work on every possible entity that will ever exist. It's fine to have highly specialized states that only get used for one thing, such as the player.

## The node this state controls. Reference this to affect the entity. Example: [code]entity.velocity.x = 0[/code]
var entity : Node

## Called when entering this state. Use for setup code.
func _enter_state() -> void: pass

## Called when exiting this state. Use for cleanup code.
func _exit_state() -> void: pass

## Exit from this state back to default state. Note that the rest of _physics_process() will continue unless you 'return' as well.
func revert(): get_parent().revert_to_default_state()

# If this node is freed, it will always reset fsm first to ensure _exit_state is run. Override this function (or comment it out) if this behavior causes problems.
func _exit_tree(): revert()
