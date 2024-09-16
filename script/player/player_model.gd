class_name FighterMesh
extends Node3D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var _playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

enum animations {NONE, IDLE, WALK, JUMP, RUN, FALL, LANDHARD, PUNCH, KICK}

func transition_to(animation_id: int) -> void:
	match animation_id:
		animations.NONE:
			_playback.stop() 
		animations.IDLE:
			_playback.travel("Idle")
		animations.WALK:
			_playback.travel("Walk")
		animations.JUMP:
			_playback.travel("Jump")
		animations.RUN:
			_playback.travel("Run")
		animations.FALL:
			_playback.travel("Fall")
		animations.LANDHARD:
			_playback.travel("LandHard")
		animations.PUNCH:
			_playback.travel("Punch")
		animations.KICK:
			_playback.travel("Kick")
