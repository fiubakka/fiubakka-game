extends Button

var is_muted := false


func _on_pressed() -> void:
	print("MUTING")
	var bus_idx := AudioServer.get_bus_index("MusicMain")
	AudioServer.set_bus_mute(bus_idx, !is_muted)
	is_muted = !is_muted
