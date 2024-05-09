extends RichTextLabel

var player_colors: Dictionary = {}
var me: String = tr("OWN_PLAYER_LABEL")

func _on_text_edit_send_message(new_message: String) -> void:
	add_new_message(me, new_message)


func add_new_message(username: String, new_message: String) -> void:
	# TODO: format other player messages with other colors
	var user := "[" + username + "]"
	if username != me:
		user = "[color=#ffaaaa]" + user + "[/color]"
	var line := user + ": " + new_message + "\n"
	append_text(line)
