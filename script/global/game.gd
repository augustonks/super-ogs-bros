extends Node

const SLOW_MOTION_DURATION: float = .025

const SLOW_MOTION_SCALE: float = .25

const NORMAL_TIME_SCALE: float = 1.0

var _restoring_normal_speed := false

func trigger_slow_motion(soft_restore := false):
	Engine.time_scale = SLOW_MOTION_SCALE

	var timer = get_tree().create_timer(SLOW_MOTION_DURATION)
	await timer.timeout
	if soft_restore:
		_restoring_normal_speed = true
	else:
		_restore_normal_speed()


func _restore_normal_speed():
	Engine.time_scale = NORMAL_TIME_SCALE


func _physics_process(delta: float) -> void:
	if _restoring_normal_speed:
		Engine.time_scale = move_toward(Engine.time_scale, NORMAL_TIME_SCALE, 10 * delta)
		if Engine.time_scale == NORMAL_TIME_SCALE:
			_restoring_normal_speed = false
