extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()
