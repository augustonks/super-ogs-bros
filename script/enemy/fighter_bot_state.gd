class_name FighterBotState
extends FighterState

@onready var _player: Player = get_tree().get_first_node_in_group("player")
@onready var _fighter_ai: FighterAI = get_tree().get_first_node_in_group("fighter_ai")

var _is_player_next := false
var _current_direction: int = -1


func physics_process(delta: float) -> void:
	_fighter.current_direction = _current_direction
