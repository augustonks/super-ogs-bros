class_name Fighter
extends CharacterBody3D

@onready var mesh: FighterMesh = $Mesh
@onready var _hurtbox: Hurtbox = $Mesh/Hurtbox
@onready var _state_machine: StateMachine = $StateMachine

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	_hurtbox.connect("hitbox_entered", _hitbox_entered)


func _hitbox_entered(hitbox: Hitbox) -> void:
	pass
