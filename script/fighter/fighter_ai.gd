class_name FighterAI
extends Node

@export var _state_machine: StateMachine
@export var _mesh: FighterMesh
@export var _move_state: FighterBotState

@onready var _attack_radius := $AttackRadius
@onready var _player_radius := $PlayerRadius
@onready var _wall_check := $WallCheck
@onready var floor_check := $FloorCheck
@onready var _fighter := get_parent()

var _player: Player
var is_player_near := false
var is_wall_near := false
var follow_player := false
var run := false
var attack_player := false

var timer

func _ready() -> void:


	_player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	is_player_near = false
	is_wall_near = false

	for body in _attack_radius.get_overlapping_bodies():
		if body is Player:
			is_player_near = true

	for body in _player_radius.get_overlapping_bodies():
		if body is Player:
			pass

	if _wall_check.is_colliding():
		is_wall_near = true

	if not floor_check.is_colliding() and not follow_player and abs(_fighter.rotation_degrees.y) == 90:
		_move_state.current_direction *= -1
