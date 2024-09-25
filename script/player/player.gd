class_name Player
extends Fighter

@onready var debug := $Debug

func _process(delta: float) -> void:
	super(delta)
	
	var velocity_x = String("%0.2f" % velocity.x)
	var velocity_y = String("%0.2f" % velocity.y)
	debug.text = str(
		"FPS: ", Engine.get_frames_per_second(),  "\n",
		"State: ", _state_machine.state.name, "\n",
		"Velocity X: ", velocity_x, " Y: ", velocity_y, "\n",
		"Facing Direction: ", current_direction, "\n",
		"Press END to reset scene")
	
	if Input.is_action_just_pressed("ui_end"):
		get_tree().reload_current_scene()
