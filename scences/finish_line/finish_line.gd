extends Area2D

@export var player: SignalBus.FinishedPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.player_finished.emit(player)

func _on_body_exited(_body: Node2D) -> void:
	SignalBus.player_finished.emit(player)
