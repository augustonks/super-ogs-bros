extends FighterBotState

var timer

func enter(params := []) -> void:
	super()
	
	if not _fighter_ai.follow_player:
		timer = get_tree().create_timer(1)
		await timer.timeout
		if not processing:
			return
		_state_machine.transition_to("Move/Idle")


func physics_process(delta: float) -> void:
	if _parent.current_speed == WALK_SPEED:
		_mesh.transition_to(_mesh.animations.WALK)
	elif _parent.current_speed >= MIN_RUN_SPEED and _parent.current_speed <= MAX_RUN_SPEED:
		_mesh.transition_to(_mesh.animations.RUN)

	super(delta)
	_parent.handle_movement(delta)
	_parent.physics_process(delta)
	if not processing:
		return
	
	if _fighter.is_on_floor() and abs(_fighter.velocity.x) <= .1:
		_state_machine.transition_to("Move/Idle")
	
	if !_fighter.is_on_floor():
		_state_machine.transition_to("Move/Air")
