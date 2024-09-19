class_name PlayerState
extends FighterState

var _input_axis: int



func _ready() -> void:
	super()


func physics_process(delta: float) -> void:
	super(delta)
	_input_axis = _get_input_axis()


func _get_input_axis() -> int:
	return Input.get_axis("left", "right")


func _update_velocity(delta: float, direction: int) -> void:
	# Checa se o state filho ainda esta sendo processado (Idle sendo filho, e Move um parente, por exemplo)
	if not sub_state.processing:
		return
	
	if direction:
		# Caso haja a direçao mude repentinamente, lutador nao perde velocidade
		if direction != _previous_direction and direction != 0 and _fighter.velocity.x != 0:
			if _fighter.is_on_floor() and _is_accelerating:
				_fighter.velocity.x = direction * current_speed * RUN_BOOST
			else:
				_fighter.velocity.x = direction * current_speed 

		# Lutador recebe pequeno impulso quando começa a se movimentar
		if _fighter.velocity.x == 0:
			if _fighter.is_on_floor():
				_fighter.velocity.x = direction * current_speed * RUN_BOOST
			else:
				_fighter.velocity.x = direction * current_speed

		# Começa a acelerar depois do boost de velocidade inicial
		if _get_difference_between(_fighter.velocity.x, MIN_RUN_SPEED) < .5 and not _is_accelerating:
			_is_accelerating = true
			_acceleration_timer = get_tree().create_timer(.05)

		if (_is_accelerating and _acceleration_timer.time_left == 0):
			_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * MAX_RUN_SPEED, MAX_SPEED_ACCELERATION * delta)
		# Idependentemente de como a movimentaçao começou (apos o flip ou nao), a velocidade transiciona
		# de volta para o padrao
		else:
			_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * current_speed, BOOST_FRICTION * delta)

	else:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, FRICTION * delta)
		if abs(_fighter.velocity.x) <= .1:
			_is_accelerating = false



func _rotate_mesh(delta) -> void:
	if abs(_input_axis) > .1:
		var tween = get_tree().create_tween()
		tween.tween_property(_fighter, "rotation_degrees:y", _input_axis * 90, .1)
		_mesh.direction = _input_axis


func _add_friction(delta: float, friction: float) -> void:
	_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, friction * delta)


func _update_speed() -> void:
	current_speed = WALK_SPEED if Input.is_action_pressed("walk") else MIN_RUN_SPEED


func _get_difference_between(x, y) -> float:
	return abs(abs(x)-abs(y))
