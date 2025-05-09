extends Node2D

const MENU = preload("res://ui/menu/menu.tscn")
const LEVEL = preload("res://scences/level.tscn")
const HUD = preload("res://ui/hud/hud.tscn")

func _ready() -> void:
	open_menu()

func open_menu():
	# Create the main menu
	var menu = MENU.instantiate()
	menu.name = "Menu"
	add_child(menu)
	menu.start_button.pressed.connect(_on_start_button_pressed)
	menu.level_select_input.text_submitted.connect(_on_level_select_input_text_submitted)
	menu.level_select_input.gui_input.connect(menu._on_level_select_input_gui_input)
	menu.level_select_input.text_changed.connect(menu._on_level_select_input_text_changed)

func close_menu():
	# Remove the main menu
	var menu = $Menu
	menu.start_button.pressed.disconnect(_on_start_button_pressed)
	menu.level_select_input.text_submitted.disconnect(_on_level_select_input_text_submitted)
	menu.level_select_input.gui_input.disconnect(menu._on_level_select_input_gui_input)
	menu.level_select_input.text_changed.disconnect(menu._on_level_select_input_text_changed)
	menu.queue_free()

func start_level(level_name: String = "start"):
	# Create the level and hud
	print(level_name)
	var level = LEVEL.instantiate()
	level.name = "Level"
	add_child(level)
	var hud = HUD.instantiate()
	hud.name = "HUD"
	add_child(hud)
	hud.quit_button.pressed.connect(_on_quit_button_pressed)

func quit_level():
	# Remove the level and hud
	var level = $Level
	level.queue_free()
	var hud = $HUD
	hud.quit_button.pressed.disconnect(_on_quit_button_pressed)
	hud.queue_free()

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
