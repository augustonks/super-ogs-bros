class_name PlayerState
extends State

var _player: Player
var _mesh: FighterMesh
var _input_axis: float
var current_speed = WALK_SPEED

const WALK_SPEED := 2.5
const RUN_SPEED := 5.0
const ACCELERATION := 70
const FRICTION := 70
const JUMP_VELOCITY := 9
const FALL_MULTIPLIER := 1.75


func _ready() -> void:
	super()
	await owner.ready
	_player = owner
	_mesh = _player.mesh


func physics_process(delta: float) -> void:
	_input_axis = _get_input_axis()


func _get_input_axis() -> float:
	return Input.get_axis("left", "right")


func _update_velocity(delta: float, direction: int) -> void:
	if direction:
		_player.velocity.x = move_toward(_player.velocity.x, direction * current_speed, ACCELERATION * delta)
		
	else:
		_player.velocity.x = move_toward(_player.velocity.x, 0, FRICTION * delta)


func _apply_gravity(delta) -> void:
	if not _player.is_on_floor():
		_player.velocity.y = clamp(_player.velocity.y, -25, 1000)
		if _player.velocity.y < 0:
			_player.velocity += _player.get_gravity() * FALL_MULTIPLIER * delta
			return
		_player.velocity += _player.get_gravity() * delta


func _rotate_mesh(delta) -> void:
	if abs(_input_axis) > .1:
		var tween = get_tree().create_tween()
		tween.tween_property(_player, "rotation_degrees:y", _input_axis * 90, .1)


func add_friction(delta: float, friction: float) -> void:
	_player.velocity.x = move_toward(_player.velocity.x, 0, friction * delta)


func _update_speed() -> void:
	current_speed = WALK_SPEED if Input.is_action_pressed("walk") else RUN_SPEED
