extends Button

signal mute_toggled

var is_muted := false


func _on_pressed() -> void:
	SoundManager.toggle_mute()
	mute_toggled.emit()
