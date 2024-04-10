extends Button


func _on_pressed() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.play()
