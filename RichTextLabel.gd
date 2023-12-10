extends RichTextLabel

var player_colors = {}

func _ready():
	pass


func _process(delta):
	pass


func _on_text_edit_send_message(new_message):
	add_new_message("You", new_message)
	
func add_new_message(username, new_message):
	# TODO: format other player messages with other colors
	text += "[" + username + "] : " + new_message + "\n"
