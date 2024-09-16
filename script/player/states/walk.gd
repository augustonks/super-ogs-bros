extends PlayerState


func physics_process(delta: float) -> void:
	if _parent.current_speed == WALK_SPEED:
		_mesh.transition_to(_mesh.animations.WALK)
	elif _parent.current_speed == RUN_SPEED:
		_mesh.transition_to(_mesh.animations.RUN)

	_parent.physics_process(delta)
	
	if _player.is_on_floor() and _player.velocity.length() <= .1:
		_state_machine.transition_to("Move/Idle")
	
	if !_player.is_on_floor():
		_state_machine.transition_to("Move/Air")
