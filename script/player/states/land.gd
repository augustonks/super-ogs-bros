extends PlayerState

func enter(_params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.LANDHARD)
	await _mesh.animation_tree.animation_finished
	_state_machine.transition_to("Move/Idle")
