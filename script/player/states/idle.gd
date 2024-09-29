extends FighterBotState


func enter(_params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.IDLE)



func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	_rotate_mesh(delta, _fighter.current_direction)
	if not processing:
		return
	
	if _fighter.is_on_floor() and abs(_fighter.velocity.x) > .1:
		_state_machine.transition_to("Move/Walk")

	if not _fighter.is_on_floor():
		_state_machine.transition_to("Move/Air")
