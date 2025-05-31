extends Node

@warning_ignore("unused_signal")
signal game_over
enum FinishedPlayer {SUN, MOON}
@warning_ignore("unused_signal")
signal level_finished
@warning_ignore("unused_signal")
signal player_finished(player: FinishedPlayer)
@warning_ignore("unused_signal")
signal play_song(song: String)
