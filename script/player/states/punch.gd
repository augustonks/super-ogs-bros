extends PlayerState

@onready var _attack_duration: Timer = $AttackDuration
@export var _hitbox: Hitbox
@export var _move_state: PlayerState

var _enter_rotation: int
var _given_combos := 0
var _attack_next := false
var _attack_state: int
var _attacks_time := {
	"idle": .3,
	"walk": .3,
	"kickair": .35,
}

const MAX_COMBOS := 2

enum attack_states {IDLE_ATTACK, WALK_ATTACK, KICK_AIR}


func enter(_params := []) -> void:
	super()
	var attack_type: int
	if Input.is_action_just_pressed("attack1"):
		attack_type = 1
	elif Input.is_action_just_pressed("attack2"):
		attack_type = 2
	_enter_rotation = _fighter.current_direction
	_fighter.rotation_degrees.y = _fighter.current_direction * 90

	if _fighter.is_on_floor():
		if attack_type == 1:
			_attack_state = attack_states.IDLE_ATTACK
			_idle_attack()

		elif attack_type == 2:
			if _fighter.is_on_floor():
				_attack_state = attack_states.WALK_ATTACK
				_walk_attack()
	else:
		_attack_state = attack_states.KICK_AIR
		_kick_air()

	_hitbox.current_attack_type = attack_states.keys()[_attack_state].to_lower()


func physics_process(delta: float) -> void:
	super(delta)
	if Input.is_action_just_pressed("attack1") and _attack_state == attack_states.IDLE_ATTACK:
		_attack_next = true

	if _attack_state == attack_states.KICK_AIR:
		_apply_gravity(delta, 1)
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 3.0 * _fighter.current_direction, 10 * delta)
		if _fighter.is_on_floor():
			_state_machine.transition_to("Move/Idle")

	if _attack_state == attack_states.IDLE_ATTACK:
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 0, 25 * delta)

	_fighter.current_direction = _enter_rotation
	
	_fighter.move_and_slide()


func _idle_attack() -> void:
	_fighter.velocity.y = 0
	if _fighter.velocity.x != 0:
		_fighter.velocity.x = _fighter.current_direction * IDLE_PUNCH_IMPULSE
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
		_idle_attack()
	else:
		_given_combos = 0
		_state_machine.transition_to("Move/Idle")


func _walk_attack() -> void:
	_mesh.transition_to(_mesh.animations.WALKATTACK, true)
	_fighter.velocity.x = 11 * _fighter.current_direction
	_attack_duration.start(_attacks_time["walk"])
	await _attack_duration.timeout
	if not processing:
		return
	_state_machine.transition_to("Move/Idle")


func _kick_air() -> void:
	_mesh.transition_to(_mesh.animations.KICKAIR, true)
	_fighter.velocity.x = 12 * _fighter.current_direction
	_jump(.6)
	_attack_duration.start(_attacks_time["kickair"])
	await _attack_duration.timeout
	if not processing:
		return
	_state_machine.transition_to("Move/Air", false)
