extends Node

@onready var menu: AudioStreamPlayer = $Menu
@onready var cave: AudioStreamPlayer = $Cave
@onready var morning: AudioStreamPlayer = $Morning
@onready var mountain: AudioStreamPlayer = $Mountain
@onready var evening: AudioStreamPlayer = $Evening

@onready var current_song: AudioStreamPlayer = $Menu

func _ready() -> void:
	SignalBus.play_song.connect(_on_play_song)

func _on_play_song(song: String):
	match song:
		"cave":
			fade(current_song, cave)
		"morning":
			fade(current_song, morning)
		"mountain":
			fade(current_song, mountain)
			current_song = mountain
		"evening":
			fade(current_song, evening)
		_:
			fade(current_song, menu)

func fade(audio: AudioStreamPlayer, new_audio: AudioStreamPlayer) -> void:
	if audio == new_audio:
		return
	current_song = new_audio
	new_audio.volume_db = -80
	new_audio.play()
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", -80, 1.0).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(new_audio, "volume_db", 0, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(audio.stop)
