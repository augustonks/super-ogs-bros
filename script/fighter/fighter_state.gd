class_name FighterState
extends State

var _fighter: Fighter
var _mesh: FighterMesh

var current_speed = MIN_RUN_SPEED
var _is_accelerating := false
var _acceleration_timer
var _previous_direction: int
var _knockback_force: Vector3 = Vector3.ZERO
var _is_knockbacking: bool = false
var _knockback_started: bool = false
var _apply_impulse_once: bool = false
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
const MAX_JUMPS: int = 10
const _JUMP_CANCEL_FACTOR: float = 0.7
const FRICTION_CONSTANT: float = 60.0
const JUMP_DELAY: float = 0.01

signal knockback_finished


func _ready() -> void:
	super()
	await owner.ready
	_fighter = owner
	_mesh = _fighter.mesh


func physics_process(delta) -> void:
	if _is_knockbacking:
		_apply_impulse(delta)


func _apply_gravity(delta) -> void:
	if not _fighter.is_on_floor():
		_fighter.velocity.y = clamp(_fighter.velocity.y, -10, 1000)
		if _fighter.velocity.y < 0:
			_fighter.velocity += _fighter.get_gravity() * FALL_MULTIPLIER * delta
			return
		_fighter.velocity += _fighter.get_gravity() * delta


func _apply_impulse(delta:float) -> void:
	_knockback_force = _knockback_force.lerp(Vector3.ZERO, 20 * delta)
	_fighter.velocity = _knockback_force

	if _knockback_force.length() < 0.1: 
		_knockback_force = Vector3.ZERO
		_is_knockbacking = false
		emit_signal("knockback_finished")


func _update_velocity(delta: float, direction: int) -> void:
	# Checa se o state filho ainda esta sendo processado (Idle sendo filho, e Move um parente, por exemplo)
	if not sub_state.processing:
		return

	if direction:
		# Caso haja a direçao mude repentinamente, lutador nao perde velocidade
		if direction != _previous_direction and direction != 0 and _fighter.velocity.x != 0:
			if _fighter.is_on_floor() and _is_accelerating:
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
		if _get_difference_between(_fighter.velocity.x, MIN_RUN_SPEED) < .5 and not _is_accelerating:
			_is_accelerating = true
			_acceleration_timer = get_tree().create_timer(.05)

		if (_is_accelerating and _acceleration_timer.time_left == 0):
			_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * MAX_RUN_SPEED, MAX_SPEED_ACCELERATION * delta)
		# Idependentemente de como a movimentaçao começou (apos o flip ou nao), a velocidade transiciona
		# de volta para o padrao
		else:
			_fighter.velocity.x = move_toward(_fighter.velocity.x, direction * current_speed, BOOST_FRICTION * delta)

	else:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, FRICTION * delta)
		if abs(_fighter.velocity.x) <= .1:
			_is_accelerating = false


func _jump() -> void:
	_remaining_jumps -= 1
	_fighter.velocity.y = JUMP_VELOCITY


func _rotate_mesh(delta: float, direction_x: float) -> void:
	if abs(direction_x) > .1:
		var tween = get_tree().create_tween()
		tween.tween_property(_fighter, "rotation_degrees:y", direction_x * 90, .1)
		_mesh.direction = direction_x


func _add_friction(delta: float, friction: float) -> void:
	_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, friction * delta)


func _get_difference_between(x, y) -> float:
	return abs(abs(x)-abs(y))
