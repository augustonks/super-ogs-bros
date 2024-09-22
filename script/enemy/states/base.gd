extends FighterState


func enter(params := []) -> void:
	_mesh.transition_to(_mesh.animations.IDLE)

func physics_process(delta) -> void:
	_apply_gravity(delta)

	_fighter.move_and_slide()
