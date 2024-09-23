extends Node

const SLOW_MOTION_DURATION: float = .025

const SLOW_MOTION_SCALE: float = .25

const NORMAL_TIME_SCALE: float = 1.0

func trigger_slow_motion():
	Engine.time_scale = SLOW_MOTION_SCALE

	var timer = get_tree().create_timer(SLOW_MOTION_DURATION)
	timer.connect("timeout", _restore_normal_speed)


func _restore_normal_speed():
	Engine.time_scale = NORMAL_TIME_SCALE
