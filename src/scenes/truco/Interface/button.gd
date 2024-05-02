extends Button

class_name TrucoButton

func _on_pressed() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.play()
