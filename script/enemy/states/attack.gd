extends FighterBotState

@onready var _attack_duration: Timer = $AttackDuration

var _given_combos := 0
var _attack_next := false

const MAX_COMBOS := 2

func enter(_params := []) -> void:
	super()
	_hit()


func physics_process(delta: float) -> void:
	if _fighter_ai.is_player_near:
		_attack_next = true

	_fighter.move_and_slide()


func _hit() -> void:
	_fighter.velocity = Vector3.ZERO
	match _given_combos:
		0:
			_mesh.transition_to(_mesh.animations.ATTACK1, true)
		1:
			_mesh.transition_to(_mesh.animations.ATTACK2, true)
	_attack_duration.start()
	await _attack_duration.timeout
	if not processing:
		return
	_given_combos += 1
	if (_attack_next and _given_combos < MAX_COMBOS):
		_attack_next = false
		_hit()
	else:
		_given_combos = 0
		_state_machine.transition_to("Move/Idle")


func exit() -> void:
	super()
	_given_combos = 0
