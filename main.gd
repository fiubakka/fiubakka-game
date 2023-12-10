extends Node

signal set_player_id
signal update_player_pos
signal change_velocity

@export var other_placer_scene: PackedScene

var other_players = {}
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = $Player.get_viewport_rect().size
	$TCPPeer.init_pos($Player.position, screen_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("open_chat") and !$Chatbox.visible):
		$Chatbox.visible = true
		$Chatbox.focus_chat()
	if (Input.is_action_pressed("close_chat") and $Chatbox.visible):
		$Chatbox.visible = false


func _on_tcp_peer_set_player_id(id):
	set_player_id.emit(id)


func _on_tcp_peer_update_player_pos(new_position):
	update_player_pos.emit(new_position)


func _on_player_change_velocity(velocity):
	change_velocity.emit(velocity)


func _on_tcp_peer_create_other_player(id, position):
	var other_player = other_placer_scene.instantiate()
	other_player.id = id
	other_player.position = position
	other_players[id] = other_player
	add_child(other_player)


func _on_tcp_peer_update_other_player_pos(id, position):
	if (other_players.has(id)):
		var other_player = other_players[id]
		other_player.position = position
	else:
		var other_player = other_placer_scene.instantiate()
		other_player.id = id
		other_player.position = position
		other_players[id] = other_player
		add_child(other_player)
