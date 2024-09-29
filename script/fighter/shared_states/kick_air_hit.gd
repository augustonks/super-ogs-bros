extends FighterStruckState


func enter(_params := []):
	super()
	_mesh.transition_to(_mesh.animations.AIRHIT, false, true)
	_hit_knockback(hitbox.current_attack_type)
	_jump(.5)
	_parent.timer.start(.3)
	await _parent.timer.timeout
	_state_machine.transition_to(next_state)
