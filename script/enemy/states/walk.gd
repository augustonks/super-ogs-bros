extends FighterBotState

var timer
var _following_player := false

func enter(_params := []) -> void:
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

	if not _fighter_ai.follow_player:
		if _following_player:
			_following_player = false
			_state_machine.transition_to("Move/Idle")
			return

	else:
		_following_player = true

	if (_fighter.is_on_floor() and abs(_fighter.velocity.x) <= .1):
		_state_machine.transition_to("Move/Idle")
	
	if (not _fighter.is_on_floor()) or (_fighter_ai.is_wall_near and _fighter_ai.has_step_up):
		_state_machine.transition_to("Move/Air")
