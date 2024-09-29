class_name FighterAI
extends Node

@export var _state_machine: StateMachine
@export var _move_state: FighterBotState

@onready var _attack_radius := $AttackRadius
@onready var _player_radius := $PlayerRadius
@onready var _wall_check := $WallCheck
@onready var _step_up_check := $StepUpCheck
@onready var floor_check := $FloorCheck
@onready var _action_timer := $ActionTimer
@onready var _fighter: FighterBot = get_parent()

var _player: Player
var is_player_close := false
var is_player_near := false
var is_wall_near := false
var has_step_up := false
var follow_player := false
var run := false
var attack_player := false

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")
	_move_state.current_speed = _move_state.WALK_SPEED


func _physics_process(_delta: float) -> void:
	is_player_near = false
	is_wall_near = false
	has_step_up = false
	attack_player = false
	
	var distance_to_player: float = _fighter.position.distance_to(_player.global_position)

	for body in _attack_radius.get_overlapping_bodies():
		if body is Player:
			is_player_close = true

	for body in _player_radius.get_overlapping_bodies():
		if body is Player:
			is_player_near = true

	if _wall_check.is_colliding():
		is_wall_near = true

	if not _step_up_check.is_colliding():
		has_step_up = true

	if not floor_check.is_colliding() and not follow_player and abs(_fighter.rotation_degrees.y) == 90:
		_move_state.current_direction *= -1

	if _player.current_state is FighterStruckState:
		follow_player = false
		attack_player = false
		_state_machine.transition_to("Move/Idle", false, ["imediate_walk"])
		return

	if is_player_near:
		if distance_to_player >= 9:
			if _action_timer.is_stopped():
				_move_state.current_speed = _move_state.WALK_SPEED
				_action_timer.start(randf_range(.3, .6))
		elif distance_to_player >= 3 and distance_to_player < 9:
			_move_state.current_speed = _move_state.WALK_SPEED
			follow_player = true
			is_player_close = false
		elif distance_to_player < 3:
			follow_player = true
			attack_player = true
			_move_state.current_speed = _move_state.MIN_RUN_SPEED

	else:
		follow_player = true
		_move_state.current_speed = _move_state.MIN_RUN_SPEED


func _on_action_timer_timeout() -> void:
	if randf() >= .5:
		follow_player = true
	else:
		follow_player = false
