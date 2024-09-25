class_name StateMachine
extends Node

@export var state: State
var transitioning: bool = false


func _ready() -> void:
	await owner.ready
	if state:
		state.enter()


func _process(delta: float) -> void:
	if state:
		state.process(delta)


func _physics_process(delta: float) -> void:
	if state:
		state.physics_process(delta)


func _input(event: InputEvent) -> void:
	if state:
		state.input(event)


func transition_to(state_path: String, reset_state: bool = false, params := []) -> void:
	if !has_node(state_path) or transitioning:
		return
	var new_state = get_node(state_path)
	
	if new_state == state and not reset_state:
		return
	
	transitioning = true
	state.exit()
	
	new_state.previous_state = state
	state = new_state
	transitioning = false
	state.enter(params)
