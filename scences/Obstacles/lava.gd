extends Node2D

@onready var texture_rect := $TextureRect
@onready var collision_shape := $Area2D/CollisionShape2D
var level
var scaleX
var scaleY

func _ready():
	$Area2D.connect("body_entered", _on_body_entered)
	$Area2D.connect("body_exited", _on_body_exited)
	texture_rect.scale = Vector2(scaleX, scaleY)
	collision_shape.position = Vector2(20, 20) * Vector2(scaleX, scaleY)
	var size = texture_rect.texture.get_size() * texture_rect.scale
	if collision_shape.shape is RectangleShape2D:
		collision_shape.shape.size = size
		$Area2D.position = texture_rect.position
	$Area2D.monitoring = true
	$Area2D.monitorable = true
		
func _on_body_entered(body: Node):
	if body == level.get_node("MoonCharacter"):
		body.get_damaged()

func _on_body_exited(body: Node):
	if body == level.get_node("MoonCharacter"):
		body.get_damaged_no_longer()
