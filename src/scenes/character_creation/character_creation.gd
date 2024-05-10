extends Control

var timer: Timer

signal return_to_menu
signal user_logged_in(username: String, password: String, equipment: Equipment)
signal register_error


func _ready() -> void:
	$NinePatchRect/VBoxContainer/MarginContainer/RichTextLabel.text = Utils.center_text(
		tr("CHAR_CREATION_TITLE")
	)
	$NinePatchRect/VBoxContainer/Character/VSplitContainer/HSplitContainer/Register/NinePatchRect/RichTextLabel.text = (
		Utils.center_text(tr("REGISTER"))
	)


func show_error_message(errorCode: String) -> void:
	if timer:
		timer.stop()
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.text = Utils.center_text(
		tr(errorCode)
	)
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = true


func _on_character_sprite_character_saved() -> void:
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = false
	var username: String = $NinePatchRect/VBoxContainer/Character/Left/Username/LoginUsername.text
	if username.is_empty():
		self.show_error_message("EMPTY_USERNAME")
		return

	var password: String = $NinePatchRect/VBoxContainer/Character/Left/Username/LoginPassword.text
	if password.is_empty():
		self.show_error_message("EMPTY_PASSWORD")
		return

	_on_timer_timeout(username, password)
	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username, password))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout(username: String, password: String) -> void:
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
	if timer:
		timer.stop()
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = false
	$NinePatchRect/VBoxContainer/Character/Left/Username/LoginUsername.clear()
	$NinePatchRect/VBoxContainer/Character/Left/Username/LoginPassword.clear()
	return_to_menu.emit()


func _on_user_init_error(_errorCode: String) -> void:
	if timer:
		timer.stop()
	register_error.emit()
