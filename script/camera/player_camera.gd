extends Camera3D

@export var _player: Player
var initial_y: float
var initial_z: float


func _ready() -> void:
	initial_y = position.y
	initial_z = position.z


func _physics_process(delta: float) -> void:
	if _player:
		global_position.x = lerp(global_position.x, _player.position.x , 5 * delta)
		if _player.is_on_floor():
			global_position.y = lerp(global_position.y, _player.position.y + initial_y, 5 * delta)
		global_position.z = lerp(global_position.z, _player.position.z + initial_z, 5 * delta)
