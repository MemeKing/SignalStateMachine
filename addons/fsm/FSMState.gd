@abstract
class_name FSMState extends Node
## Finite State Machine state node.
##
## A state represents one discrete behavior mode (e.g., Running, Dashing, Hurt). States are 
## activated/deactivated by toggling their [_physics_process] callback, which makes overlaps impossible. [br]
## States can be reused across different entitys as long as the required properties exist. Enforcement of types is at the user's discrection. [br] 

## [br][br]
## Usage :[br]
## 1. Extend this class for each unique behavior [br]
## 2. Override [_physics_process] for behavior logic [br]
## 3. Override [_enter_state()]/[_exit_state] for setup/cleanup (animations, timers, etc.) [br]
## 4. Reference [entity] for the controlled node [br] [br]
##
## Use [_enter_state] and [_exit_state] for setup and cleanup logic such as initializing variables, starting timers, or resetting values. [br][br]
## 
##Remember to have balance when creating states. Highly complex behavior can arise from simplicity, but not every little movement needs to be a state of it's own. In 2D platformers it can be ideal to have a "basic" state which controls grounded and jumping situations, in order to make the most of CharacterBody2D.  

## The node this state controls. Reference this to affect the entity. Example: [code]entity.velocity.x = 0[/code]
var entity : Node


# If this node is freed, always reset fsm to ensure _exit_state is run. Override this function (or comment it out) if this behavior causes problems and you want to manage things another way. 
func _exit_tree(): revert()

## Called when entering this state. Use for setup code.
func _enter_state() -> void: pass

## Called when exiting this state. Use for cleanup code.
func _exit_state() -> void: pass

## Resets the fsm back to it's default state. 
func revert(): get_parent().revert_to_default_state()
