class_name State
extends Node

@onready var _state_machine: StateMachine = _get_state_machine(self)
var _parent
var sub_state: State
var processing := false
var previous_state: State 


func _ready() -> void:
	_parent = get_parent() if not get_parent() is StateMachine else null


func enter(_params := []) -> void:
	#if owner.name == "Player":
		#print(name, " entered!")
	processing = true
	if _parent:
		_parent.sub_state = self


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func input(_event: InputEvent) -> void:
	pass


func exit() -> void:
	processing = false


func _get_state_machine(node: Node) -> Node:
	if node != null and not node is StateMachine:
		return _get_state_machine(node.get_parent())
	return node
