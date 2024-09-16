extends Camera3D

@export var _player: Player

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(Vector3(_player.position.x, _player.position.y + 2.5, _player.position.z + 4), 5 * delta)
