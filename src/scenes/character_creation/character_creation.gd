extends Control

var timer: Timer

signal save_character
signal return_to_menu
signal user_logged_in(username: String, equipment: Equipment)


func _on_button_pressed() -> void:
	var username: String = $NinePatchRect/VBoxContainer/Character/Left/Username/LoginUsername.text
	if username.is_empty():
		return
	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout(username: String) -> void:
	var customization := PlayerInfo.player_customization
	var equipment := Equipment.new()
	equipment.set_equipment(
		customization.hats,
		customization.hair,
		customization.eyes,
		customization.glasses,
		customization.facial_hair,
		customization.body,
		customization.outfit
	)
	save_character.emit()  #TODO: Esto creo que se puede borrar
	user_logged_in.emit(username, equipment)


func _on_return_return_to_menu() -> void:
	$NinePatchRect/VBoxContainer/Character/Left/Username/LoginUsername.clear()
	return_to_menu.emit()
