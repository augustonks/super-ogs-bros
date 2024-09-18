class_name PlayerState
extends FighterState

var _input_axis: int


func _ready() -> void:
	super()


func physics_process(delta: float) -> void:
	_input_axis = _get_input_axis()


func _get_input_axis() -> float:
	return Input.get_axis("left", "right")


func _update_velocity(delta: float, direction: int) -> void:
	if direction:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * current_speed, ACCELERATION * delta)
		
	else:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, FRICTION * delta)


func _rotate_mesh(delta) -> void:
	if abs(_input_axis) > .1:
		var tween = get_tree().create_tween()
		tween.tween_property(_fighter, "rotation_degrees:y", _input_axis * 90, .1)
		_mesh.direction = _input_axis


func _add_friction(delta: float, friction: float) -> void:
	_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, friction * delta)


func _update_speed() -> void:
	current_speed = WALK_SPEED if Input.is_action_pressed("walk") else RUN_SPEED
