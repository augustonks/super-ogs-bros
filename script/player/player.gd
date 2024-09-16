class_name Player
extends CharacterBody3D

@onready var mesh: FighterMesh = $Mesh
@onready var _label: Label = $CanvasLayer/Label
@onready var _state_machine: StateMachine = $StateMachine


func _process(delta: float) -> void:
	_label.text = str("State: ", _state_machine.state.name)
	
	if Input.is_action_just_pressed("ui_end"):
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	position.z = 0
