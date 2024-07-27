extends Control

@onready var button := $LoginButton
@onready var spinner := $Spinner


func _on_login_login_error(_errorCode: String) -> void:
	button.visible = true
	spinner.visible = false


func _on_login_user_logged_in(_username: String, _password: String, _equipment: Equipment) -> void:
	button.visible = false
	spinner.visible = true
