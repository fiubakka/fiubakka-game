extends Node

signal update_player_pos
signal set_player_id

const host = "127.0.0.1"
const port = 8000
var socket = PacketPeerUDP.new()
var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	socket.connect_to_host(host, port)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if socket.get_available_packet_count() > 0:
		var server_pkt = socket.get_packet().get_string_from_utf8()
		
		var msg = server_pkt.split(" ")
		match msg[0]:
			"POS":
				var position = Vector2(float(msg[1]), float(msg[2]))
				print(position)
				update_player_pos.emit(position)
			
			"ID":
				var id = int(msg[1])
				set_player_id.emit(id)


func init_pos(position, screen_size):
	print("mandando la pos")
	socket.put_packet(str("INIT ", position.x, " ", position.y, " ", screen_size.x, " ", screen_size.y).to_utf8_buffer())


func change_velocity(vel):
	socket.put_packet(str("VEL ", vel.x, " ", vel.y).to_utf8_buffer())


func _on_main_change_velocity(vel):
	socket.put_packet(str("VEL ", vel.x, " ", vel.y).to_utf8_buffer())
