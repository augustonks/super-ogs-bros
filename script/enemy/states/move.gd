extends FighterBotState

@export var _attack_state: FighterBotState

func physics_process(delta: float, _can_move := true, _can_jump := true) -> void:
	_previous_direction = current_direction
	super(delta)
	_apply_gravity(delta)
	_fighter.move_and_slide()


func handle_movement(delta) -> void:
	_fighter.current_direction = current_direction
	if _fighter_ai.attack_player:
		attack_player()
	if _fighter_ai.follow_player:
		follow_player()

	_update_velocity(delta, current_direction)
	_rotate_mesh(delta, current_direction)
	_previous_direction = current_direction


func follow_player() -> void:
	var distance_to_player = _fighter.position.distance_to(_player.position)
	#var player_direction := int(sign(_player.global_position.direction_to(_fighter.global_position).x))

	if distance_to_player > 1.5:
		current_direction = int(sign(_fighter.global_position.direction_to(_player.global_position).x))
	else:
		current_direction = 0

	#if _fighter_ai.is_wall_near:
		#if current_direction != player_direction and current_direction != 0 and player_direction != 0:
			#if _player.position.y > _fighter.position.y:
				#_state_machine.transition_to("Move/Air")


func attack_player():

	if _fighter_ai.is_player_near and _attack_state.can_attack:
			if _player.current_state.name != "Attack":
				_state_machine.transition_to("Attack")
			else:
				if _state_machine.state.name != "Dodge":
					var dodge_rate := randf()
					if dodge_rate >= .5:
						_state_machine.transition_to("Dodge")
					_attack_state.can_attack = false
					_attack_state.can_attack_on_exit = false
