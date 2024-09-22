class_name FighterAI
extends Node

@export var _state_machine: StateMachine
@export var _move_state: FighterBotState

@onready var _attack_radius := $AttackRadius
@onready var _wall_check := $WallCheck
@onready var _fighter := get_parent()

var _player: Player
var is_player_near := false
var is_wall_near := false

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	is_player_near = false
	is_wall_near = false
	for body in _attack_radius.get_overlapping_bodies():
		if body is Player:
			is_player_near = true

	if _wall_check.is_colliding():
		is_wall_near = true
