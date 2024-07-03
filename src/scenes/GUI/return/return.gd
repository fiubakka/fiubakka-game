extends Button

signal return_to_menu

func _on_pressed() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.play()
	return_to_menu.emit()
