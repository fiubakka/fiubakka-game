extends Node2D

@export var other_placer_scene: PackedScene
@export var room_200_scene: PackedScene

var other_players = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("open_chat") and 
		!$Player/Chatbox.visible and
		!$Player/Chatbox.idle):
		$Player/Chatbox.visible = true
		$Player/Chatbox.focus_chat()
	if (Input.is_action_pressed("close_chat") and
		$Player/Chatbox.visible and
		!$Player/Chatbox.idle):
		$Player/Chatbox.visible = false

func _on_tcp_peer_update_other_player_pos(id, position, velocity):
	if (other_players.has(id)):
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
		

func _on_login_change_to_room_200_scene():
	var room_200 = room_200_scene.instantiate()
	print("main will add room_200 scene")
	add_child(room_200)
	print(get_children())
	print(room_200.change_scene)
	$Player.visible = true
	$Player.idle = false
	$Player/Chatbox.idle = false
