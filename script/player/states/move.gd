extends PlayerState


func physics_process(delta: float, can_move := true, can_jump := true) -> void:
	super(delta)
	_apply_gravity(delta)
	_handle_movement(delta, can_move, can_jump)


func _handle_movement(delta: float, can_move: bool, can_jump: bool) -> void:
	_update_speed()
	if can_jump:
		if Input.is_action_just_pressed("jump") and _player.is_on_floor():
			_state_machine.transition_to("Move/Air")
	
	if Input.is_action_just_pressed("attack"):
		_state_machine.transition_to("Punch")

	if can_move:
		_update_velocity(delta, _get_input_axis())
	_rotate_mesh(delta)
	_player.move_and_slide()
