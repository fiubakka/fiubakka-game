extends Control

signal init_tcp_peer
signal change_to_zone_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_user_input_text_submitted(username: String):
	var trimmed_username = username.replace(" ", "")
	print(trimmed_username)
	if !trimmed_username.is_empty():
		init_tcp_peer.emit(trimmed_username)
		change_to_zone_scene.emit()
		get_node(".").queue_free()
