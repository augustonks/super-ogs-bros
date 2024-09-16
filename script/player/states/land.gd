extends PlayerState

func enter(params := []) -> void:
	_mesh.transition_to(_mesh.animations.LANDHARD)
	await _mesh.animation_tree.animation_finished
	_state_machine.transition_to("Move/Idle")
