extends FighterBotState

var timer

func enter(params := []) -> void:
	super()
	_mesh.transition_to(_mesh.animations.IDLE)
	if _fighter_ai.follow_player:
		return

	_fighter.velocity.x = 0
	_parent.current_direction = 0

	var idle_wait: bool = true
	if params and params[0] != "imediate_walk": # De FighterAi
		idle_wait = false

	if idle_wait:
		timer = get_tree().create_timer(randf_range(1, 1.5))
		await timer.timeout
		if not processing or _fighter_ai.follow_player:
			return
	else:
		print("iomediata walk")

	if randf() > .3:
		_parent.current_direction = randi() % 2 * 2 - 1
		_state_machine.transition_to("Move/Walk")
	else: 
		_state_machine.transition_to("Move/Air")


func physics_process(delta: float) -> void:
	super(delta)
	_parent.physics_process(delta)
	_parent.handle_movement(delta)

	if _fighter.is_on_floor(): 
		if abs(_fighter.velocity.x) > .1:
			_state_machine.transition_to("Move/Walk")
	else:
		_state_machine.transition_to("Move/Air")
