extends Node2D

@export var other_placer_scene: PackedScene
@export var room_200_scene: PackedScene

var other_players = {}


func _process(_delta: float) -> void:
	if Input.is_action_pressed("open_chat") and !$Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = true
		$Player/Chatbox.focus_chat()
	if Input.is_action_pressed("close_chat") and $Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = false


func _on_tcp_peer_update_other_player_pos(id, position, velocity):
	if other_players.has(id):
		var other_player = other_players[id]
		other_player.position = position
		other_player.velocity = velocity
	else:
		var other_player = other_placer_scene.instantiate()
		other_player.id = id
		other_player.position = position
		other_player.velocity = velocity
		other_player.player_name = id
		other_players[id] = other_player
		add_child(other_player)


func _on_login_user_logged_in(_username: String) -> void:
	add_child(room_200_scene.instantiate())
	get_node("Login").queue_free()
	$Player.visible = true
	$Player.idle = false
	# $Player/Chatbox.idle = false
