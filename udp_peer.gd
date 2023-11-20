extends Node

signal update_player_pos
signal set_player_id
signal create_other_player

const host = "127.0.0.1"
const port = 8000
#var socket = PacketPeerUDP.new()
var socket = StreamPeerTCP.new()
var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var error = socket.connect_to_host(host, port)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if socket.get_available_bytes() > 0:
		var server_str = socket.get_string()
		
		var msg = server_str.split(" ")
		match msg[0]:
			"POS":
				var position = Vector2(float(msg[1]), float(msg[2]))
				update_player_pos.emit(position)
			
			"ID":
				var id = int(msg[1])
				set_player_id.emit(id)
			
			"NEW_PLAYER":
				var id = int(msg[1])
				var position = Vector2(float(msg[2]), float(msg[3]))
				print(id)
				print(position)
				create_other_player.emit(id, position)


func init_pos(position, screen_size):
	print("mandando la pos")
	socket.put_string(str("INIT ", position.x, " ", position.y, " ", screen_size.x, " ", screen_size.y))


func change_velocity(vel):
	socket.put_string(str("VEL ", vel.x, " ", vel.y))


func _on_main_change_velocity(vel):
	socket.put_data(str("VEL a", vel.x, " ", vel.y).to_ascii_buffer())
