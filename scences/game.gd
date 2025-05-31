extends Node2D

const MENU = preload("res://ui/menu/menu.tscn")
const LEVEL = preload("res://scences/level.tscn")
const HUD = preload("res://ui/hud/hud.tscn")

const CAVE = preload("res://scences/levels/cave.tscn")
const EVENING = preload("res://scences/levels/evening.tscn")
const MORNING = preload("res://scences/levels/morning.tscn")
const MOUNTAIN = preload("res://scences/levels/mountain.tscn")

@onready var menu: CanvasLayer = $Menu
@onready var hud: CanvasLayer = $HUD
@onready var game_over: CanvasLayer = $GameOver
@onready var level_finished: CanvasLayer = $LevelFinished

@onready var levels: Node2D = $Levels
var current_level: StringName = &"start"
var next_level: StringName = &"start"

enum Level {CURRENT, NEXT};
var sun_finished: bool = false
var moon_finished: bool = false

func _ready() -> void:
	# Connect main menu signals
	menu.start_button.pressed.connect(_on_start_button_pressed.bind("cave"))
	menu.level_select_input.text_submitted.connect(_on_start_button_pressed)
	# Connect hud signals
	hud.quit_button.pressed.connect(_on_quit_button_pressed)
	hud.restart_button.pressed.connect(_on_level_transition.bind(Level.CURRENT))
	# Connect game over signals
	game_over.restart_button.pressed.connect(_on_level_transition.bind(Level.CURRENT))
	game_over.menu_button.pressed.connect(_on_quit_button_pressed)
	SignalBus.game_over.connect(_on_game_over)
	# Connect finish level signals
	level_finished.next_button.pressed.connect(_on_level_transition.bind(Level.NEXT))
	level_finished.restart_button.pressed.connect(_on_level_transition.bind(Level.CURRENT))
	level_finished.menu_button.pressed.connect(_on_quit_button_pressed)
	SignalBus.player_finished.connect(_on_player_finished)

func open_menu():
	# Make the main menu visible
	menu.visible = true
	SignalBus.play_song.emit("menu")

func close_menu():
	# Make the main menu invisible
	menu.visible = false

func select_level(level_name: String) -> Node:
	match level_name:
		"cave":
			current_level = "cave"
			SignalBus.play_song.emit("cave")
			next_level = "morning"
			return CAVE.instantiate()
		"morning":
			current_level = "morning"
			SignalBus.play_song.emit("morning")
			next_level = "mountain"
			return MORNING.instantiate()
		"mountain":
			current_level = "mountain"
			SignalBus.play_song.emit("mountain")
			next_level = "evening"
			return MOUNTAIN.instantiate()
		"evening":
			current_level = "evening"
			SignalBus.play_song.emit("evening")
			next_level = "cave"
			return EVENING.instantiate()
		"start":
			current_level = "start"
			SignalBus.play_song.emit("menu")
			current_level = "start"
			return LEVEL.instantiate()
		_:
			return null

func start_level(level_name: String) -> bool:
	var level = select_level(level_name)
	# Check if level exists
	if not level:
		return false
	hud.visible = true
	hud.password.text = level_name
	moon_finished = false
	sun_finished = false
	# Add the level in the game
	level.name = "Level"
	levels.add_child(level)
	return true

func quit_level():
	hud.visible = false
	game_over.visible = false
	# Remove the level
	var level = $Levels/Level
	levels.remove_child(level)
	level.queue_free()
	level_finished.visible = false

func _on_start_button_pressed(level_name: String) -> void:
	# Close the main menu and start selected level
	close_menu()
	if not start_level(level_name):
		open_menu()

func _on_quit_button_pressed() -> void:
	# Quit the level and open the main menu
	quit_level()
	open_menu()

func _on_level_transition(level: Level) -> void:
	# Transitino to another level
	quit_level()
	match level:
		Level.NEXT:
			# Get to next level
			start_level(next_level)
		_:
			# Restart current level
			start_level(current_level)

func _on_game_over() -> void:
	game_over.visible = true

func _on_player_finished(player: SignalBus.FinishedPlayer) -> void:
	match player:
		SignalBus.FinishedPlayer.MOON:
			moon_finished = not moon_finished
		SignalBus.FinishedPlayer.SUN:
			sun_finished = not sun_finished
	if moon_finished and sun_finished:
		level_finished.visible = true
		SignalBus.level_finished.emit()
