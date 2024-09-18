class_name FighterState
extends State

var _fighter: Fighter
var _mesh: FighterMesh

var current_speed = WALK_SPEED
var _knockback_force: Vector3 = Vector3.ZERO
var _is_knockbacking: bool = false
var _knockback_started: bool = false
var _apply_impulse_once: bool = false

const WALK_SPEED := 2.5
const RUN_SPEED := 5.0
const ACCELERATION := 70
const FRICTION := 70
const JUMP_VELOCITY := 9
const FALL_MULTIPLIER := 1.75
const PUNCH_KNOCKBACK_FORCE := 10.0

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
		_fighter.velocity.y = clamp(_fighter.velocity.y, -25, 1000)
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
