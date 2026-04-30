@abstract
class_name FSMState extends Node
## Class for states used by the [SignalStateMachine] node.
##
## Extend this class to create a new state. All state behavior must be implemented
## in physics_process. State nodes are turned "on" and "off" using their physics_process.
## When physics_process is turned on, the state's physics_process will not run 
## until the next physics frame, ensuring two states don't run simultaneously.


## The node that this state is acting on. [br]
## [code]actor = actor as Type[/code] will give you code completion in the script editor.
var actor : Node

## Code to run when entering this state. Runs before physics_process. Use for 
## setting up timers or whatever else. Optional.
func _enter_state() -> void: pass

## Code to run when exiting this state. Runs after physics_process. Optional.
func _exit_state() -> void: pass


func _physics_process(delta: float) -> void : pass


## Reset the fsm back to it's default state. 
func revert(): get_parent().revert_to_default_state()
