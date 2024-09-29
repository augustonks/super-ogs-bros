extends Control

@export var _player: Player
@export var _bot: FighterBot

@onready var _player_info := $PlayerInfo
@onready var _bot_info := $BotInfo
@onready var _help_window := $HelpWindow
@onready var _help_text := $HelpText



func _process(_delta: float) -> void:
	var p_velocity_x = String("%0.2f" % _player.velocity.x)
	var p_velocity_y = String("%0.2f" % _player.velocity.y)

	var b_velocity_x = String("%0.2f" % _bot.velocity.x)
	var b_velocity_y = String("%0.2f" % _bot.velocity.y)

	_player_info.text = str(
		"FPS: ", Engine.get_frames_per_second(),  "\n",
		"Player Info", "\n",
		"State: ", _player.current_state.name, "\n",
		"Velocity X: ", p_velocity_x, " Y: ", p_velocity_y, "\n",
		"Facing Direction: ", _player.current_direction, "\n",
		)

	_bot_info.text = str(
		"\n",
		"Bot Info", "\n",
		"State: ", _bot.current_state.name, "\n",
		"Velocity X: ", b_velocity_x, " Y: ", b_velocity_y, "\n",
		)


	if Input.is_action_just_pressed("tab"):
		get_tree().paused = !get_tree().paused
		_help_window.visible = !_help_window.visible

	if Input.is_action_just_pressed("f3"):
		_player_info.visible = !_player_info.visible
		_bot_info.visible = !_bot_info.visible
		_help_text.visible = !_help_text.visible

	if Input.is_action_just_pressed("ui_end"):
		if get_tree().paused == true:
			get_tree().paused = false
		get_tree().reload_current_scene()
