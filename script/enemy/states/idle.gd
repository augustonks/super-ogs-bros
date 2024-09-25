extends FighterBotState

var timer

func enter(params := []) -> void:
	super()
	if _fighter_ai.follow_player:
		if not _fighter.is_on_floor():
			_state_machine.transition_to("Move/Air")
			return
		_state_machine.transition_to("Move/Walk")
		return

	_fighter.velocity.x = 0
	_parent.current_direction = 0
	_mesh.transition_to(_mesh.animations.IDLE)

	timer = get_tree().create_timer(randf_range(1, 1.5))
	await timer.timeout
	if not processing:
		return
	_parent.current_direction = randi() % 2 * 2 - 1
	_state_machine.transition_to("Move/Walk")


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
