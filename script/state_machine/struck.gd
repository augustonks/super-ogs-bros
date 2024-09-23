extends FighterState

@export var next_state: String
var _hitbox: Hitbox
var _direction: Vector2
var timer


func enter(params := []) -> void:
	_fighter.velocity = Vector3.ZERO
	_hitbox = params[0]
	_direction = check_hit_direction()
	match _hitbox.current_attack_type:
		"walk_attack":
			if _fighter.is_on_floor():
				_stumble()
			else:
				_idle_hit()
		"kick_air":
			if not _fighter.is_on_floor():
				_kick_air_hit()
			else:
				_idle_hit()
		"idle_attack":
			if not _fighter.is_on_floor():
				_kick_air_hit()
			else:
				_idle_hit()
	Game.trigger_slow_motion()


func physics_process(delta: float) -> void:
	super(delta)
	_fighter.move_and_slide()


func _stumble():
	_mesh.transition_to(_mesh.animations.STUMBLE, false, true)
	_hit_knockback(_hitbox.current_attack_type)
	timer = get_tree().create_timer(1)
	await timer.timeout
	_state_machine.transition_to(next_state)


func _kick_air_hit():
	_mesh.transition_to(_mesh.animations.AIRHIT, false, true)
	_hit_knockback(_hitbox.current_attack_type)
	_jump(.5)
	timer = get_tree().create_timer(.3)
	await timer.timeout
	_state_machine.transition_to(next_state)


func _idle_hit():
	_mesh.transition_to(_mesh.animations.IDLEHIT, false, true)
	_hit_knockback(_hitbox.current_attack_type)
	timer = get_tree().create_timer(.5)
	await timer.timeout
	_state_machine.transition_to(next_state)


func _hit_knockback(type: String):
	match type:
		"walk_attack":
			_knockback_force = Vector3(-_direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
		"kick_air":
			_knockback_force = Vector3(_direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
		"idle_hit":
			_knockback_force = Vector3(_direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
	_is_knockbacking = true


func check_hit_direction() -> Vector2:
	var x: int
	if _hitbox.owner.global_position.x > _fighter.global_position.x:
		x = -1
	else:
		x = 1
	return Vector2(x, 0)


func exit():
	super()
	_fighter.velocity = Vector3.ZERO
