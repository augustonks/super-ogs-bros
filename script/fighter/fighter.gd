class_name Fighter
extends CharacterBody3D

@onready var move_state: FighterState = $StateMachine/Move
@onready var mesh: FighterMesh = $Mesh
@onready var _hitbox: Hitbox = $Hitbox
@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _state_machine: StateMachine = $StateMachine
@onready var _state_display: Label3D = $StateDisplay

@export var _show_current_state := true 

var current_direction := -1
var current_state: State


func _ready() -> void:
	_hurtbox.connect("hitbox_entered", _hitbox_entered)
	current_state = _state_machine.state


func _process(_delta: float) -> void:
	current_state = _state_machine.state
	
	if _show_current_state:
		_state_display.text = str("State: ", _state_machine.state.name)


func _physics_process(_delta: float) -> void:
	position.z = 0


func _hitbox_entered(hitbox: Hitbox) -> void:
	if not hitbox == _hitbox and _state_machine.state.name != "Dodge":
		_state_machine.transition_to("Struck", true, [hitbox])
