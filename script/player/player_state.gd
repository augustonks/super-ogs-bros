class_name PlayerState
extends FighterState

var _input_axis: int


func _ready() -> void:
	super()


func physics_process(delta: float) -> void:
	super(delta)
	_input_axis = _get_input_axis()
	if (_input_axis != 0 
	and not (_state_machine.state.name == "Air"
	and _state_machine.state.previous_state.name == "Attack")):
		_fighter.current_direction = _input_axis


func _get_input_axis() -> int:
	return Input.get_axis("left", "right")


func _update_speed() -> void:
	current_speed = WALK_SPEED if Input.is_action_pressed("walk") else MIN_RUN_SPEED
