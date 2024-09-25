class_name FighterStruckState
extends FighterState

@export var next_state: String = "Move/Idle"

var hitbox: Hitbox
var direction: Vector2

var hitbox_attack_type: String


func physics_process(delta: float) -> void:
	super(delta)
	if _parent:
		_parent.physics_process(delta)


func _hit_knockback(type: String):
	match type:
		"walk_attack":
			_knockback_force = Vector3(-direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
		"kick_air":
			_knockback_force = Vector3(direction.x * PUNCH_KNOCKBACK_FORCE, 0, 0)
		"idle_attack":
			_knockback_force = Vector3(direction.x * IDLE_PUNCH_IMPULSE, 0, 0)
	_is_knockbacking = true


func check_hit_direction() -> Vector2:
	var x: int = hitbox.owner.current_direction

	return Vector2(x, 0)
