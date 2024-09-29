extends FighterBotState

@onready var _attack_duration: Timer = $AttackDuration
@export var _hitbox: Hitbox

var _attack_disable_timer := Timer.new()
var _given_combos := 0
var _attack_next := false
var _attack_state: int
var _attacks_time := {
	"idle": .3,
	"walk": .3,
	"kickair": .35,
}

var can_attack := true
var can_attack_on_exit := true

const MAX_COMBOS := 2

enum attack_states {IDLE_ATTACK, WALK_ATTACK, KICK_AIR}


func _ready() -> void:
	super()
	add_child(_attack_disable_timer)
	_attack_disable_timer.one_shot = true


func enter(_params := []) -> void:
	super()
	can_attack = false
	if _fighter.is_on_floor():
		if abs(_fighter.velocity.x) > .5:
			_attack_state = attack_states.WALK_ATTACK
			_walk_attack()
		else:
			_attack_state = attack_states.IDLE_ATTACK
			_idle_attack()
	else:
		_attack_state = attack_states.KICK_AIR
		_kick_air()
	_hitbox.current_attack_type = attack_states.keys()[_attack_state].to_lower()


func _process(_delta: float) -> void:
	if not can_attack_on_exit:
		if _attack_disable_timer.is_stopped():
			_attack_disable_timer.start(.5)
			await _attack_disable_timer.timeout
			can_attack = true
			can_attack_on_exit = true


func physics_process(delta: float) -> void:
	if _fighter_ai.is_player_near and _attack_state == attack_states.IDLE_ATTACK:
		_attack_next = true

	if _attack_state == attack_states.KICK_AIR:
		_apply_gravity(delta, 1)
		_fighter.velocity.x = move_toward(_fighter.velocity.x, 3.0 * _fighter.current_direction, 10 * delta)
		if _fighter.is_on_floor():
			_state_machine.transition_to("Move/Idle")
			return

	_fighter.move_and_slide()


func _idle_attack() -> void:
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



func exit() -> void:
	super()
	_given_combos = 0
	_fighter.velocity.x = 0
	_attack_disable_timer.start()
	await _attack_disable_timer.timeout
	if can_attack_on_exit:
		can_attack = true
