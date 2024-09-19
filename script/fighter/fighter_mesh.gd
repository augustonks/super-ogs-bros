class_name FighterMesh
extends Node3D

@onready var _playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

@export var animation_tree: AnimationTree
@export var _tracker: AnimationPlayer

var direction: int

enum animations {IDLE, WALK, JUMP, RUN, FALL, LANDHARD, ATTACK1, ATTACK2}

func transition_to(animation_id: int, has_tracker: bool = false, reset: bool = false) -> void:
	var animation_string = animations.keys()[animation_id].capitalize().replace(" ", "")
	if not reset:
		_playback.travel(animation_string)
	else:
		_playback.start(animation_string)

	if has_tracker:
		_tracker.play("Attack1")
