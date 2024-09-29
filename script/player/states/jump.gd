extends PlayerState

var _previous_velocity_y: float
var _enter_rotation: float

@export var _hitbox: Hitbox

func enter(_params := []) -> void:
	_enter_rotation = _fighter.rotation_degrees.y
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
	_parent.physics_process(delta, true, true, false)
	
	if not processing:
		return

	if previous_state and previous_state.name == "Attack":
		_fighter.rotation_degrees.y = _enter_rotation
	else:
		_rotate_mesh(delta, _fighter.current_direction)


func input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and _remaining_jumps > 0:
		_mesh.transition_to(_mesh.animations.FALL, false, true)
		previous_state = self
		_jump()

	if event.is_action_released("jump") and _remaining_jumps == MAX_JUMPS - 1:
		_fighter.velocity.y *= _JUMP_CANCEL_FACTOR


func _handle_animation() -> void:
	if _state_machine.state == self:
		if _fighter.velocity.y < 2:
			if previous_state.name != "Attack":
				_mesh.transition_to(_mesh.animations.FALL)
				return
		else:
			_mesh.transition_to(_mesh.animations.JUMP)


func exit() -> void:
	super()
	_hitbox.collision_shape.disabled = true
