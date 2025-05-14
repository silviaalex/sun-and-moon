extends CanvasLayer

@onready var clickable = $TextureRect
var game_node

func _ready():
	clickable.connect("gui_input", _on_gui_input)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		self.visible = false
		game_node.quit_level()
		game_node.start_level()
