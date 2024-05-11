extends Node

var _is_muted := false


func toggle_mute() -> void:
	var bus_idx := AudioServer.get_bus_index("MusicMain")
	AudioServer.set_bus_mute(bus_idx, !_is_muted)
	_is_muted = !_is_muted


func is_muted() -> bool:
	return _is_muted
