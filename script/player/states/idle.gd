extends PlayerState


func enter(_params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.IDLE)


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
	if not _processing:
		return
	
	if _fighter.is_on_floor() and abs(_fighter.velocity.x) > .1:
		_state_machine.transition_to("Move/Walk")

	if not _fighter.is_on_floor():
		_state_machine.transition_to("Move/Air")
