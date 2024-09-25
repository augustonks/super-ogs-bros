class_name FighterBot
extends Fighter

@onready var debug := $Debug

func _process(delta: float) -> void:
	super(delta)
	
	var velocity_x = String("%0.2f" % velocity.x)
	var velocity_y = String("%0.2f" % velocity.y)
	debug.text = str(
		"\n",
		"State: ", _state_machine.state.name, "\n",
		"Velocity X: ", velocity_x, " Y: ", velocity_y)
