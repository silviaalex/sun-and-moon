extends Node2D

const MENU = preload("res://ui/menu/menu.tscn")
const LEVEL = preload("res://scences/level.tscn")
const HUD = preload("res://ui/hud/hud.tscn")
const HEART = preload("res://scences/lives/Heart.tscn")
const LAVA = preload("res://scences/Obstacles/Lava.tscn")
const OOZE = preload("res://scences/Obstacles/Ooze.tscn")
const WATER = preload("res://scences/Obstacles/Water.tscn")
const SPIKES = preload("res://scences/Obstacles/Spikes.tscn")

@onready var menu: CanvasLayer = $Menu
@onready var hud: CanvasLayer = $HUD

@onready var levels: Node2D = $Levels
@onready var hearts: Node2D = $Hearts
@onready var obstacles: Node2D = $Obstacles
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
	
func instantiate_the_hearts():
	# Instantiate players' lives
	for child in hearts.get_children():
		child.queue_free()

	for i in range(3):
		var heart = HEART.instantiate()
		heart.name = "HeartSun%d" % (i + 1)
		heart.position = Vector2(350 + i * 40, 30)
		hearts.add_child(heart)

	for i in range(3):
		var heart = HEART.instantiate()
		heart.name = "HeartMoon%d" % (i + 1)
		heart.position = Vector2(490 + i * 40, 30)
		hearts.add_child(heart)

func instantiate_ooze(x, y, dimX, dimY, name, level):
	var ooze = OOZE.instantiate()
	ooze.name = name
	ooze.scaleX = dimX / 16.0
	ooze.scaleY = dimY / 32.0
	ooze.position = Vector2(x, y)
	ooze.level = level
	obstacles.add_child(ooze)
	return
	
func instantiate_lava(x, y, dimX, dimY, name, level):
	var lava = LAVA.instantiate()
	lava.name = name
	lava.scaleX = dimX / 16.0
	lava.scaleY = dimY / 32.0
	lava.position = Vector2(x, y)
	lava.level = level
	obstacles.add_child(lava)
	return
	
func instantiate_water(x, y, dimX, dimY, name, level):
	var water = WATER.instantiate()
	water.name = name
	water.scaleX = dimX / 16.0
	water.scaleY = dimY / 32.0
	water.position = Vector2(x, y)
	water.level = level
	obstacles.add_child(water)
	return
	
func instantiate_spikes(x, y, dimX, dimY, name, level):
	var spikes = SPIKES.instantiate()
	spikes.name = name
	spikes.scaleX = dimX / 40.0
	spikes.scaleY = dimY / 40.0
	spikes.position = Vector2(x, y)
	spikes.level = level
	obstacles.add_child(spikes)
	return

func start_level(level_name: String = "start"):
	hud.visible = true
	# Create the level
	var level = LEVEL.instantiate()
	level.name = "Level"
	levels.add_child(level)
	level.get_node("SunCharacter").game_node = self
	level.get_node("MoonCharacter").game_node = self
	level.get_node("LoseState").visible = false
	level.get_node("LoseState").game_node = self
	instantiate_the_hearts()
		
	instantiate_ooze(150, 331, 30, 5, "Ooze1", level)
	instantiate_lava(210, 331, 30, 5, "Lava1", level)
	instantiate_water(270, 331, 30, 5, "Water1", level)
	instantiate_spikes(370, 308, 40, 40, "Spikes1", level)
	# Functions instantiate_* take as parameters:
	# x, y - the coordinates where the obstacle starts
	# dimX, dimY - dimensions of obstacle
	# name - variable name
	# level - the level instance
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
