extends RichTextLabel

var messages = []

func _ready():
	pass


func _process(delta):
	pass


func _on_text_edit_send_message(new_message):
	# TODO: format other player messages with other colors
	text += "\n[You]: " + new_message
