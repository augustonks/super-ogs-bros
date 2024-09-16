extends PlayerState

var _remaining_jumps: int = _MAX_JUMPS
var _previous_velocity_y: float

const _MAX_JUMPS: int = 10
const _JUMP_CANCEL_FACTOR: float = 0.7
const FRICTION_CONSTANT: float = 60.0
const JUMP_DELAY: float = 0.01

func enter(_params := []) -> void:
	if not _player.is_on_floor():
		_remaining_jumps -= 1
		return
	_jump()


func physics_process(delta: float) -> void:
	if _state_machine.transitioning: 
		return

	if _player.is_on_floor():
		_remaining_jumps = _MAX_JUMPS
		if _previous_velocity_y < -14:
			_state_machine.transition_to("Move/Land") 
		else:
			_state_machine.transition_to("Move/Idle") 
	else:
		_handle_animation()

	_previous_velocity_y = _player.velocity.y
	_parent.physics_process(delta)


func input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and _remaining_jumps > 0:
		_jump()

	if event.is_action_released("jump") and _remaining_jumps == _MAX_JUMPS - 1:
		_player.velocity.y *= _JUMP_CANCEL_FACTOR


func _jump() -> void:
	_remaining_jumps -= 1
	_player.velocity.y = JUMP_VELOCITY


func _handle_animation() -> void:
	if _state_machine.state == self:
		if _player.velocity.y < 0:
			_mesh.transition_to(_mesh.animations.FALL)
		else:
			_mesh.transition_to(_mesh.animations.JUMP)


func exit() -> void:
	_mesh.transition_to(_mesh.animations.NONE)
