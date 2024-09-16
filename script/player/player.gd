class_name Player
extends Fighter

@onready var _label: Label = $CanvasLayer/Label


func _process(delta: float) -> void:
	_label.text = str("State: ", _state_machine.state.name)
	
	if Input.is_action_just_pressed("ui_end"):
		get_tree().reload_current_scene()
