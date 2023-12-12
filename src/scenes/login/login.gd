extends Control

signal init_tcp_peer
signal change_to_zone_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("force_login")): # force_login == L
		init_tcp_peer.emit("flu")
		change_to_zone_scene.emit()
		get_node(".").free()
