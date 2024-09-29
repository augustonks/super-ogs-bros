class_name FighterState
extends State

var _fighter: Fighter
var _mesh: FighterMesh

var current_speed = MIN_RUN_SPEED
var is_accelerating := false
var _acceleration_timer
var _previous_direction: int
var _knockback_force: Vector3 = Vector3.ZERO
var _is_knockbacking: bool = false
var _knockback_started: bool = false
var _remaining_jumps: int = MAX_JUMPS

const WALK_SPEED := 2.5
const MIN_RUN_SPEED := 5.0
const MAX_RUN_SPEED := 7.5
const RUN_BOOST := 1.5
const BOOST_FRICTION := 10
const MAX_SPEED_ACCELERATION := 10
const FRICTION := 50
const JUMP_VELOCITY := 11.0
const FALL_MULTIPLIER := 1.25
const PUNCH_KNOCKBACK_FORCE := 10.0
const IDLE_PUNCH_IMPULSE := 10.0
const MAX_JUMPS: int = 2
const _JUMP_CANCEL_FACTOR: float = 0.7
const FRICTION_CONSTANT: float = 60.0
const JUMP_DELAY: float = 0.01


func _ready() -> void:
	super()
	await owner.ready
	_fighter = owner
	_mesh = _fighter.mesh


func physics_process(delta) -> void:
	if _is_knockbacking:
		_apply_impulse(delta)


func _apply_gravity(delta: float, factor := 1) -> void:
	if not _fighter.is_on_floor():
		_fighter.velocity.y = clamp(_fighter.velocity.y, -10, 1000)
		if _fighter.velocity.y < 0:
			_fighter.velocity += _fighter.get_gravity() * FALL_MULTIPLIER * delta * factor
			return
		_fighter.velocity += _fighter.get_gravity() * delta * factor


func _apply_impulse(delta:float) -> void:
	_knockback_force.x = move_toward(_knockback_force.x, 0, 20 * delta)
	_fighter.velocity.x = _knockback_force.x

	if _knockback_force.length() < 0.1: 
		_knockback_force = Vector3.ZERO
		_is_knockbacking = false


func _update_velocity(delta: float, direction: int) -> void:
	# Checa se o state filho ainda esta sendo processado (Idle sendo filho, e Move um parente, por exemplo)
	if not sub_state.processing:
		return

	if direction:
		# Caso haja a direçao mude repentinamente, lutador nao perde velocidade
		if direction != _previous_direction and direction != 0 and _fighter.velocity.x != 0:
			if _fighter.is_on_floor() and is_accelerating and current_speed != WALK_SPEED:
				_fighter.velocity.x = direction * current_speed * RUN_BOOST
			else:
				_fighter.velocity.x = direction * current_speed 

		# Lutador recebe pequeno impulso quando começa a se movimentar
		if _fighter.velocity.x == 0:
			if _fighter.is_on_floor():
				_fighter.velocity.x = direction * current_speed * RUN_BOOST
			else:
				_fighter.velocity.x = direction * current_speed

		# Começa a acelerar depois do boost de velocidade inicial
		if current_speed != WALK_SPEED:
			if _get_difference_between(_fighter.velocity.x, MIN_RUN_SPEED) < .5 and not is_accelerating:
				is_accelerating = true
				_acceleration_timer = get_tree().create_timer(.05)

			if (is_accelerating and _acceleration_timer.time_left == 0):
					_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * MAX_RUN_SPEED, MAX_SPEED_ACCELERATION * delta)
			# Idependentemente de como a movimentaçao começou (apos o flip ou nao), a velocidade transiciona
			# de volta para o padrao
			else:
				_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * current_speed, BOOST_FRICTION * delta)
		else:
			_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * current_speed, BOOST_FRICTION * 2 * delta)

	else:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, FRICTION * delta)
		if abs(_fighter.velocity.x) <= .1:
			is_accelerating = false


func _jump(factor := 1.0) -> void:
	_remaining_jumps -= 1
	_fighter.velocity.y = JUMP_VELOCITY * factor


func _rotate_mesh(delta: float, direction_x: float) -> void:
	if direction_x == 0:
		direction_x = _previous_direction
	if abs(direction_x) > .1:
		#var tween = get_tree().create_tween()
		#tween.tween_property(_fighter, "rotation_degrees:y", direction_x * 90, .1)
		_fighter.rotation_degrees.y = move_toward(_fighter.rotation_degrees.y, direction_x * 90, 1000 * delta)
		_mesh.direction = direction_x


func _add_friction(delta: float, friction: float) -> void:
	_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, friction * delta)


func _get_difference_between(x, y) -> float:
	return abs(abs(x)-abs(y))
