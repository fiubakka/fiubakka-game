extends RichTextLabel

var player_colors: Dictionary = {}


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_text_edit_send_message(new_message: String) -> void:
	add_new_message("You", new_message)


func add_new_message(username: String, new_message: String) -> void:
	# TODO: format other player messages with other colors
	var user := "[" + username + "]"
	if username != "You":
		user = "[color=#ffaaaa]" + user + "[/color]"
	var line := user + ": " + new_message + "\n"
	append_text(line)
