extends FighterBotState


func enter(params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.IDLE)
	_acceleration_timer = get_tree().create_timer(1)


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
	if not processing:
		return
	
	if _fighter.is_on_floor() and abs(_fighter.velocity.x) > .1:
		_state_machine.transition_to("Move/Walk")

	if not _fighter.is_on_floor():
		_state_machine.transition_to("Move/Air")
