extends Node

signal send_message

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_send_message(message):
	send_message.emit(message)


func _on_tcp_peer_update_content(username, content):
	$RichTextLabel.add_new_message(username, content)
