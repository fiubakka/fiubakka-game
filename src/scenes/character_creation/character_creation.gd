extends Control

var timer: Timer

signal save_character
signal return_to_menu
signal user_logged_in(username: String)


func _on_button_pressed() -> void:
	var username: String = $NinePatchRect/VBoxContainer/Character/Left/Username/LoginUsername.text
	if username.is_empty():
		return
	timer = Timer.new() # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout(username: String) -> void:
	save_character.emit()
	user_logged_in.emit(username)


func _on_return_return_to_menu() -> void:
	return_to_menu.emit()
