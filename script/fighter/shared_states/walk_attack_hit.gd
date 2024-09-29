extends FighterStruckState


func enter(_params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.STUMBLE, false, true)
	_hit_knockback(hitbox.current_attack_type)
	_parent.timer.start(1)
	await _parent.timer.timeout
	if not processing:
		return
	_state_machine.transition_to(next_state)


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
	_apply_gravity(delta)
