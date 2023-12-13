extends Node2D

@export var other_placer_scene: PackedScene
@export var zone_scene: PackedScene

var other_players = {}
var other_players_label = {}
var screen_size
const pattern = "^Player-(.*)$"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("open_chat") and !$Chatbox.visible):
		$Chatbox.visible = true
		$Chatbox.focus_chat()
	if (Input.is_action_pressed("close_chat") and $Chatbox.visible):
		$Chatbox.visible = false


func _on_tcp_peer_create_other_player(id, position):
	var other_player = other_placer_scene.instantiate()
	other_player.id = id
	other_player.position = position
	other_players[id] = other_player
	add_child(other_player)


func _on_tcp_peer_update_other_player_pos(id, position, velocity):
	if (other_players.has(id)):
		var other_player = other_players[id]
		other_player.position = position
		other_player.velocity = velocity
		var label = other_players_label[id]
		label.position = Vector2(other_player.position.x - 35, other_player.position.y - 100)
	else:
		var other_player = other_placer_scene.instantiate()
		other_player.id = id
		other_player.position = position
		other_player.velocity = velocity
		other_players[id] = other_player
		add_child(other_player)
		var nameLabel = Label.new()
		nameLabel.text = get_username_from_id(other_player.id) # Because id is like Player-username and we want to show only the name
		nameLabel.position = Vector2(other_player.position.x - 35, other_player.position.y - 100) # TODO: There must be a way to handle the position dynamically instead of magic numbers
		other_players_label[id] = nameLabel
		add_child(nameLabel)
		

func get_username_from_id(id):
	var regex = RegEx.new()
	var username
	regex.compile(pattern)
	var match = regex.search(id)
	if match:
		username = match.get_string(1)
	else:
		username = id
	return username
	

func _on_login_change_to_zone_scene():
	var zone = zone_scene.instantiate()
	print("main will add zone scene")
	add_child(zone)
	print(get_children())
	print(zone.change_scene)
	zone.change_scene.connect(_mi_metodo_handler)
	$Player.visible = true
	$Player.idle = false
	
	
func _mi_metodo_handler(mensaje):
	print(mensaje)
