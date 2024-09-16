class_name Fighter
extends CharacterBody3D

@onready var mesh: FighterMesh = $Mesh
@onready var _hitbox: Hitbox = $Hitbox
@onready var _hurtbox: Hurtbox = $Hurtbox
@onready var _state_machine: StateMachine = $StateMachine

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	_hurtbox.connect("hitbox_entered", _hitbox_entered)


func _physics_process(delta: float) -> void:
	position.z = 0


func _hitbox_entered(hitbox: Hitbox) -> void:
	if not hitbox == _hitbox:
		_state_machine.transition_to("Struk")
