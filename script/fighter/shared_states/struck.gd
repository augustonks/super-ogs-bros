extends FighterStruckState

var timer := Timer.new()

func _ready() -> void:
	super()
	timer.one_shot = true
	add_child(timer)


func enter(params := []) -> void:
	super()
	_fighter.velocity = Vector3.ZERO
	hitbox = params[0]
	direction = check_hit_direction()
	for child in get_children():
		if child is FighterStruckState:
			child.hitbox = hitbox
			child.direction = direction
	_fighter.current_direction = -direction.x
	_fighter.rotation_degrees.y = 90 * _fighter.current_direction
	match hitbox.current_attack_type:
		"walk_attack":
			if _fighter.is_on_floor():
				_state_machine.transition_to("Struck/WalkAttackHit")
			else:
				_state_machine.transition_to("Struck/IdleAttackHit")
		"kick_air":
			if not _fighter.is_on_floor():
				_state_machine.transition_to("Struck/KickAirkHit")
			else:
				_state_machine.transition_to("Struck/IdleAttackHit")
		"idle_attack":
			if not _fighter.is_on_floor():
				_state_machine.transition_to("Struck/KickAirkHit")
			else:
				_state_machine.transition_to("Struck/IdleAttackHit")
	Game.trigger_slow_motion()


func physics_process(delta: float) -> void:
	super(delta)
	_fighter.move_and_slide()


func exit():
	super()
	_fighter.velocity = Vector3.ZERO
