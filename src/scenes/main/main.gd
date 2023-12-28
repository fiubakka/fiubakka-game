extends Node2D

const Room200Scene = preload("res://src/scenes/maps/room_200/room_200.tscn")

var other_players = {}


func _process(_delta: float) -> void:
	if Input.is_action_pressed("open_chat") and !$Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = true
		$Player/Chatbox.focus_chat()
	if Input.is_action_pressed("close_chat") and $Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = false


# func _on_tcp_peer_update_other_player_pos(id, position, velocity):
# 	if other_players.has(id):
# 		var other_player = other_players[id]
# 		other_player.position = position
# 		other_player.velocity = velocity
# 	else:
# 		var other_player = other_placer_scene.instantiate()
# 		other_player.id = id
# 		other_player.position = position
# 		other_player.velocity = velocity
# 		other_player.player_name = id
# 		other_players[id] = other_player
# 		add_child(other_player)


func _on_server_consumer_user_init_ready(_position: Vector2) -> void:
	add_child(Room200Scene.instantiate())
	#TODO: Is it okay to change the initial position of the player like this or should we use something else
	# like signals for example?
	var player := get_node("Room200").get_node("Player")
	player.position = _position
	get_node("Login").queue_free()
	# $Player/Chatbox.idle = false
