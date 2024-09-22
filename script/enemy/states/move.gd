extends FighterBotState


func physics_process(delta: float, can_move := true, can_jump := true) -> void:
	_previous_direction = _current_direction
	super(delta)
	_apply_gravity(delta)
	_handle_movement(delta)
	_fighter.move_and_slide()


func _handle_movement(delta) -> void:
	_current_direction = 0
	var player_direction := int(sign(_player.global_position.direction_to(_fighter.global_position).x))

	_current_direction = int(sign(_fighter.global_position.direction_to(_player.global_position).x))

	if _fighter_ai.is_player_near:
		_state_machine.transition_to("Attack")

	if _fighter_ai.is_wall_near:
		if _current_direction != player_direction and _current_direction != 0 and player_direction != 0:
			if _player.position.y > _fighter.position.y:
				_state_machine.transition_to("Move/Air")

	_update_velocity(delta, _current_direction)
	_rotate_mesh(delta, _current_direction)
