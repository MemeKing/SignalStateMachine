# Epic State Machine

## Intro
This addon implements a finite state machine using signals between an fsm node and attachable state nodes.
The design came from HeartBeast's tutorial on Finite State Machines, and the behavior does not differ very much. 
However there is an "FSMState" class and template, as well as a function to help link states.

## Classes

### FiniteStateMachine
#### Properties
`state`: points to the currently running state node. Modifying this won't trigger change_state() so don't bother.

#### Functions
`_change_state(new_state)` : For internal use but you can force a state switch if you have an fsmstate to switch to.

`link()` : Use this in the _ready() function of your root node to link signals to states. See below example for more.

### FSMState

#### Properties
`actor` : represents the root node which the fsm is acting on.

#### Functions

`_enter_state()` : For setup that needs to be done every time the state is entered, such as setting timers or modifying hitboxes.
`_exit_state()` : Runs every time the state is exited, even if physics_process() was cut off early. 
`_physics_process()` : You must use physics_process for the state's behavior.

### Example Characterbody2D script using fsm

```gd
extends CharacterBody2D

@onready var fsm = $FiniteStateMachine
@onready var normal_state = $FiniteStateMachine/ExampleRunaround
@onready var noclip_state = $FiniteStateMachine/ExampleNoclipState

func _ready() -> void:
	fsm.link(normal_state,"enter_noclip",noclip_state)
	fsm.link(noclip_state,"exited_noclip",normal_state)
```

### Example of a state script

```
class_name CHANGE_TO_NAME_OF_STATE
extends FSMState

signal fell_in_pit

func _enter_state(): pass

func _exit_state(): pass

func _physics_process(_delta: float) -> void:
	if actor.y < 0: fell_in_pit.emit()
```

## Credits

Heartbeast https://www.youtube.com/watch?v=qwOM3v8T33Q

pixel-boy for icon https://pixel-boy.itch.io/icon-godot-node
