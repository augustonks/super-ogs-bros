extends Camera3D

@export var _fighter1: Fighter
@export var _fighter2: Fighter
var initial_y: float
var initial_z: float


func _ready() -> void:
	initial_y = position.y
	initial_z = position.z


func _physics_process(delta: float) -> void:
	if _fighter1 and _fighter2:

		var z = _fighter1.position.distance_to(_fighter2.position)
		z = clamp(z, 5.2, 10.0)
	
		var target_position = (_fighter1.global_position + _fighter2.global_position) / 2
		global_position.x = lerp(global_position.x, target_position.x , 5 * delta)


		global_position.y = lerp(global_position.y, target_position.y + 1.8, 5 * delta)
		global_position.z = lerp(global_position.z, z, 5 * delta)
