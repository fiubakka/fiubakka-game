extends Node

signal update_player_pos
signal set_player_id
signal create_other_player
signal update_other_player_pos

const PBPlayerInit = preload("res://compiled/init/player_init.gd")
const PBPlayerVelocity = preload("res://compiled/velocity/player_velocity.gd")
const PBMetadata = preload("res://compiled/common/metadata.gd")

const host = "127.0.0.1"
const port = 9090
var socket = StreamPeerTCP.new()
var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var error = socket.connect_to_host(host, port)
	if error:
		print("fail")
	socket.poll()
	print(socket.get_status())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if socket.get_available_bytes() > 0:
		var res = socket.get_partial_data(1024)
		var error = res[0]
		var read_bytes: PackedByteArray = res[1]
		
		var server_str = read_bytes.get_string_from_ascii()
		
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
				create_other_player.emit(id, position)
			
			"OTHER_PLAYER_POS":
				var id = int(msg[1])
				var position = Vector2(float(msg[2]), float(msg[3]))
				print(id, position)
				update_other_player_pos.emit(id, position)


func init_pos(position, screen_size):
	var player_init = PBPlayerInit.PBPlayerInit.new()
	player_init.set_username("Flu")
	var player_init_bytes = player_init.to_bytes()
	
	send_protocol_buffer(player_init_bytes, PBMetadata.PBMessageType.PBPlayerInit)
	
	
func _on_main_change_velocity(vel):
	var player_velocity = PBPlayerVelocity.PBPlayerVelocity.new()
	player_velocity.set_username("Flu")
	player_velocity.set_x(vel.x)
	player_velocity.set_y(vel.y)
	var player_velocity_bytes = player_velocity.to_bytes()
	
	send_protocol_buffer(player_velocity_bytes, PBMetadata.PBMessageType.PBPlayerVelocity)
	
	
func send_protocol_buffer(msg_bytes, type):
	var metadata = PBMetadata.PBMetadata.new()
	metadata.set_type(type)
	metadata.set_length(msg_bytes.size())
	
	var metadata_bytes = metadata.to_bytes()
	var metadata_size_bytes = int_to_big_endian_bytes(metadata_bytes.size())
	
	socket.put_data(metadata_size_bytes + metadata_bytes + msg_bytes)	
	
	
func int_to_big_endian_bytes(value: int) -> PackedByteArray:
	var buffer = PackedByteArray()

	# Pack the integer into a buffer using big-endian format
	buffer.resize(4)
	buffer[0] = (value >> 24) & 0xFF
	buffer[1] = (value >> 16) & 0xFF
	buffer[2] = (value >> 8) & 0xFF
	buffer[3] = value & 0xFF

	return buffer
