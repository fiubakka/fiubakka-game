extends Control

var timer: Timer

signal save_character
signal return_to_menu
signal user_logged_in(username: String, password: String, equipment: Equipment)

var username: String = ""
var password: String = ""


func _ready() -> void:
	$NinePatchRect/VBoxContainer/MarginContainer/RichTextLabel.text = Utils.center_text(
		tr("CHAR_CREATION_TITLE")
	)
	$NinePatchRect/VBoxContainer/Character/VSplitContainer/HSplitContainer/Register/NinePatchRect/RichTextLabel.text = (
		Utils.center_text(tr("REGISTER"))
	)


func _on_login_username_text_submitted(_new_text: String) -> void:
	self._on_button_pressed()


func _on_login_password_text_submitted(_new_text: String) -> void:
	self._on_button_pressed()


func _on_login_username_text_changed(_username: String) -> void:
	username = _username


func _on_login_password_text_changed(_password: String) -> void:
	password = _password


func show_error_message(errorCode: String) -> void:
	if timer:
		timer.stop()
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.text = Utils.center_text(
		tr(errorCode)
	)
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = true


func _on_user_init_error(errorCode: String) -> void:
	self.show_error_message(errorCode)


func _on_button_pressed() -> void:
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = false
	if username.is_empty():
		self.show_error_message("EMPTY_USERNAME")
		return

	if password.is_empty():
		self.show_error_message("EMPTY_PASSWORD")
		return

	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout() -> void:
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
	save_character.emit()
	user_logged_in.emit(username, password, equipment)


func _on_return_return_to_menu() -> void:
	username = ""
	password = ""
	if timer:
		timer.stop()
	$NinePatchRect/VBoxContainer/Character/Left/Username/RegisterErrorText.visible = false
	return_to_menu.emit()


func _on_language_select_switch_locale() -> void:
	$NinePatchRect/VBoxContainer/MarginContainer/RichTextLabel.text = Utils.center_text(
		tr("CHAR_CREATION_TITLE")
	)
	$NinePatchRect/VBoxContainer/Character/VSplitContainer/HSplitContainer/Register/NinePatchRect/RichTextLabel.text = (
		Utils.center_text(tr("REGISTER"))
	)
