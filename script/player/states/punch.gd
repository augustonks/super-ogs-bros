extends PlayerState

var _given_combos := 0
var _attack_next := false

const MAX_COMBOS := 2

func enter(_params := []) -> void:
	_player.velocity.y = 0
	_hit()


func physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		_attack_next = true


func _hit() -> void:
	match _given_combos:
		0:
			_mesh.transition_to(_mesh.animations.PUNCH)
		1:
			_mesh.transition_to(_mesh.animations.KICK)
	await _mesh.animation_tree.animation_finished
	_given_combos += 1
	if (_attack_next and _given_combos < MAX_COMBOS):
		_attack_next = false
		_hit()
	else:
		_state_machine.transition_to("Move/Idle")

func exit() -> void:
	_given_combos = 0
