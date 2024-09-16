extends PlayerState


func enter(_params := []) -> void:
	_mesh.transition_to(_mesh.animations.IDLE)


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
	
	if _player.is_on_floor() and abs(_player.velocity.x) > .1:
		_state_machine.transition_to("Move/Walk")

	if not _player.is_on_floor():
		_state_machine.transition_to("Move/Air")
