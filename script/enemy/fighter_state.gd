class_name FighterState
extends State

var _fighter: Fighter
var _mesh: FighterMesh

func _ready() -> void:
	await owner.ready
	_fighter = owner
	_mesh = _fighter.mesh
