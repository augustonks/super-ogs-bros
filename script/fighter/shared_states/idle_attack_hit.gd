extends FighterStruckState


func enter(params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.IDLEHIT, false, true)
	_hit_knockback(hitbox.current_attack_type)
	_parent.timer.start(.5)
	await _parent.timer.timeout
	_state_machine.transition_to(next_state)
