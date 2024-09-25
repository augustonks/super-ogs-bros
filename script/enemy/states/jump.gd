extends FighterBotState

@export var _wall_check: RayCast3D
@export var _hitbox: Hitbox

func enter(params := []) -> void:
	super()
	if _remaining_jumps > 0:
		_jump()


func physics_process(delta: float) -> void:
	if not processing:
		return

	if _fighter.is_on_floor():
		_remaining_jumps = MAX_JUMPS
		if _fighter.velocity.length() > .1:
			_state_machine.transition_to("Move/Walk") 
		else:
			_state_machine.transition_to("Move/Idle") 
	else:
		_handle_animation()
		if _fighter.velocity.y < 0:
			if _wall_check.is_colliding():
				_state_machine.transition_to("Move/Idle") 

	_parent.handle_movement(delta)
	_parent.physics_process(delta)


func _handle_animation() -> void:
	if _state_machine.state == self:
		if _fighter.velocity.y < 2:
			_mesh.transition_to(_mesh.animations.FALL)
		else:
			_mesh.transition_to(_mesh.animations.JUMP)


func exit() -> void:
	super()
	_hitbox.collision_shape.disabled = true
