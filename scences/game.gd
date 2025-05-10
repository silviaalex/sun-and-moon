extends Node2D

const MENU = preload("res://ui/menu/menu.tscn")
const LEVEL = preload("res://scences/level.tscn")
const HUD = preload("res://ui/hud/hud.tscn")

@onready var menu: CanvasLayer = $Menu
@onready var hud: CanvasLayer = $HUD

@onready var levels: Node2D = $Levels
var last_level : StringName = &"start"

func _ready() -> void:
	menu.visible = true
	hud.visible = false
	menu.start_button.pressed.connect(_on_start_button_pressed)
	menu.level_select_input.text_submitted.connect(_on_level_select_input_text_submitted)
	menu.level_select_input.gui_input.connect(menu._on_level_select_input_gui_input)
	menu.level_select_input.text_changed.connect(menu._on_level_select_input_text_changed)
	hud.quit_button.pressed.connect(_on_quit_button_pressed)
	hud.restart_button.pressed.connect(_on_restart_button_pressed)

func open_menu():
	# Make the main menu visible
	menu.visible = true

func close_menu():
	# Make the main menu invisible
	menu.visible = false

func start_level(level_name: String = "start"):
	hud.visible = true
	# Create the level
	var level = LEVEL.instantiate()
	level.name = "Level"
	levels.add_child(level)
	print(level_name)

func quit_level():
	hud.visible = false
	# Remove the level
	var level = $Levels/Level
	levels.remove_child(level)
	level.queue_free()

func _on_start_button_pressed() -> void:
	# Close the main menu and start first level
	close_menu()
	start_level()

func _on_level_select_input_text_submitted(new_text: String) -> void:
	# Close the main menu and start selected level
	close_menu()
	start_level(new_text)

func _on_quit_button_pressed() -> void:
	# Quit the level and open the main menu
	quit_level()
	open_menu()

func _on_restart_button_pressed() -> void:
	quit_level()
	start_level()
