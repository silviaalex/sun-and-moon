extends CanvasLayer

@onready var start_button: Button = %StartButton
@onready var level_select_input: LineEdit = %LevelSelectInput
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
	level_select_input.gui_input.connect(_on_level_select_input_gui_input)
	level_select_input.text_changed.connect(_on_level_select_input_text_changed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_level_select_input_gui_input(_event: InputEvent) -> void:
	# Make sure to have cursor on the last character
	level_select_input.caret_column = level_select_input.text.length()

func _on_level_select_input_text_changed(new_text: String) -> void:
	# Make sure to keep ASCII characters that are numbers, letters or signs
	new_text = new_text.to_lower()
	var i = 0
	while i < len(new_text):
		var unicode = new_text.unicode_at(i)
		if not (unicode >= 0x20 and unicode <= 0x7e):
			new_text = new_text.erase(i, 1)
		i += 1
	level_select_input.text = new_text

func _on_quit_button_pressed() -> void:
	# Quit the game
	get_tree().quit()
