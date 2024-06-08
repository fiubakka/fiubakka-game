extends Button

class_name TrucoButton


func _on_pressed() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.play()


func set_min_size(min_size: Vector2) -> void:
	custom_minimum_size = min_size
