extends FighterState


func enter(_params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.DODGE)
	if owner is FighterBot:
		await get_tree().create_timer(1).timeout
		_state_machine.transition_to("Move/Idle")


func physics_process(delta: float) -> void:
	super(delta)
	_apply_gravity(delta)
	_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, FRICTION * delta)
	_fighter.move_and_slide()


func input(event: InputEvent) -> void:
	if owner is Player:
		if event.is_action_released("dodge"):
			_state_machine.transition_to("Move/Idle")
