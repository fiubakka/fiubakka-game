extends Control

var timer: Timer

signal return_to_menu
signal user_logged_in(username: String, password: String, equipment: Equipment)
signal register_error(errorCode: String)
signal error_clear

var username: String = ""
var password: String = ""


func _on_login_username_text_changed(_username: String) -> void:
	username = _username


func _on_login_password_text_changed(_password: String) -> void:
	password = _password


func _on_user_init_error(errorCode: String) -> void:
	if timer:
		timer.stop()
	register_error.emit(errorCode)


func _on_character_sprite_character_saved() -> void:
	error_clear.emit()
	if username.is_empty():
		register_error.emit("EMPTY_USERNAME")
		return

	if password.is_empty():
		register_error.emit("EMPTY_PASSWORD")
		return

	_send_register_request()
	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.set_wait_time(10.0)
	timer.start()
	
func _on_timer_timeout() -> void:
	if timer:
		timer.stop()
	register_error.emit("TIMEOUT")


func _send_register_request() -> void:
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
	user_logged_in.emit(username, password, equipment)


func _on_return_return_to_menu() -> void:
	username = ""
	password = ""
	if timer:
		timer.stop()
	return_to_menu.emit()
