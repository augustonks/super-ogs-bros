extends FighterState

@export var next_state: String
var _hitbox: Hitbox
var _direction: Vector2


func enter(params := []) -> void:
	_fighter.velocity = Vector3.ZERO
	_hitbox = params[0]
	_direction = check_hit_direction()
	_mesh.transition_to(_mesh.animations.LANDHARD, false, true)
	_knockback_force = Vector3(_direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
	_is_knockbacking = true
	await _mesh.animation_tree.animation_finished
	_state_machine.transition_to(next_state)


func physics_process(delta: float) -> void:
	super(delta)
	_fighter.move_and_slide()


func check_hit_direction() -> Vector2:
	var x: int
	if _hitbox.owner.global_position.x > _fighter.global_position.x:
		x = -1
	else:
		x = 1
	return Vector2(x, 0)


func exit():
	_fighter.velocity = Vector3.ZERO
