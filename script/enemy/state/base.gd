extends FighterState


func enter(params := []) -> void:
	_mesh.transition_to(_mesh.animations.IDLE)
