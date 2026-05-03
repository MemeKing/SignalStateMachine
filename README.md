# Signal State Machine

Finite state machine for Godot using signals between an fsm node and attachable state nodes.

Full documentation is provided but please see the "example characters" for a quick-start and demonstration of how different genres can be achieved. Feel free to use these characters in your games if they suit your purposes well enough.

Celestial: A platforming character that can dash and walljump. 

ChosenZombie: Can equip different weapons that effect movement while attacking. 

Please suggest more character types if you have ideas.

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

Heartbeast for original idea https://www.youtube.com/watch?v=qwOM3v8T33Q

Font Awesome for icon https://fontawesome.com
