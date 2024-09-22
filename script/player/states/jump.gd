extends PlayerState

var _previous_velocity_y: float

func enter(_params := []) -> void:
	super()
	if not _fighter.is_on_floor(): 
		_remaining_jumps -= 1
		return
	_jump()


func physics_process(delta: float) -> void:
	if _state_machine.transitioning: 
		return

	if _fighter.is_on_floor():
		_remaining_jumps = MAX_JUMPS
		if _fighter.velocity.length() > .1:
			_state_machine.transition_to("Move/Walk") 
		else:
			_state_machine.transition_to("Move/Idle") 
	else:
		_handle_animation()

	_previous_velocity_y = _fighter.velocity.y
	_parent.physics_process(delta)


func input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and _remaining_jumps > 0:
		_mesh.transition_to(_mesh.animations.FALL, false, true)
		_jump()

	if event.is_action_released("jump") and _remaining_jumps == MAX_JUMPS - 1:
		_fighter.velocity.y *= _JUMP_CANCEL_FACTOR


func _handle_animation() -> void:
	if _state_machine.state == self:
		if _fighter.velocity.y < 2:
			_mesh.transition_to(_mesh.animations.FALL)
		else:
			_mesh.transition_to(_mesh.animations.JUMP)
