extends PlayerState


func physics_process(delta: float, can_move := true, can_jump := true, rotate_mesh := true) -> void:
	_previous_direction = _input_axis
	super(delta)
	_apply_gravity(delta)
	_handle_movement(delta, can_move, can_jump, rotate_mesh)


func _handle_movement(delta: float, can_move: bool, can_jump: bool, rotate_mesh: bool) -> void:
	_update_speed()

	if Input.is_action_just_pressed("attack"):
		if sub_state.name == "Air" and sub_state.previous_state.name == "Attack":
			return
		_state_machine.transition_to("Attack")

	if can_jump:
		if Input.is_action_just_pressed("jump") and _fighter.is_on_floor():
			_state_machine.transition_to("Move/Air")

	if can_move:
		_update_velocity(delta, _get_input_axis())
	if rotate_mesh:
		_rotate_mesh(delta, _fighter.current_direction)

	_fighter.move_and_slide()
