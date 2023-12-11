extends Node

signal update_player_pos
signal create_other_player
signal update_other_player_pos
signal update_content

const PBPlayerInit = preload("res://compiled/client/init/player_init.gd")
const PBPlayerVelocity = preload("res://compiled/client/movement/player_velocity.gd")
const PBClientMetadata = preload("res://compiled/client/metadata.gd")
const PBClientPlayerMessage = preload("res://compiled/client/chat/message.gd")

const PBServerMetadata = preload("res://compiled/server/metadata.gd")
const PBPlayerPosition = preload("res://compiled/server/position/player_position.gd")
const PBServerPlayerMessage = preload("res://compiled/server/chat/message.gd")

const PBGameEntityState = preload("res://compiled/server/state/game_entity_state.gd")

const host = "127.0.0.1"
const port = 2020
var socket = StreamPeerTCP.new()
var connected = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var error = socket.connect_to_host(host, port)
	if error:
		print("fail")
	socket.poll()
	print("tcp peer ready")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if socket.get_available_bytes() > 0:
		var len = socket.get_data(4)
		len = big_endian_bytes_to_int(len[1])
		var res = socket.get_data(len)
		var error = res[0]
		var read_bytes: PackedByteArray = res[1]
		
		var meta_len = big_endian_bytes_to_int(read_bytes.slice(0, 4))
		
		var meta_bytes = read_bytes.slice(4, 4 + meta_len)
		
		var metadata = PBServerMetadata.PBServerMetadata.new()
		# TODO: check for errors
		metadata.from_bytes(meta_bytes)
		
		var msg_bytes = read_bytes.slice(4 + meta_len)
		
		print(metadata.get_type())
		match metadata.get_type():
			PBServerMetadata.PBServerMessageType.PBPlayerPosition:
				print("will update position")
				var player_position = PBPlayerPosition.PBPlayerPosition.new()
				var result = player_position.from_bytes(msg_bytes) # TODO: check for errors
				print(result)
				update_player_pos.emit(Vector2(player_position.get_x(), player_position.get_y()))
				
			PBServerMetadata.PBServerMessageType.PBGameEntityState:
				print("will update entity state")
				var entity_state = PBGameEntityState.PBGameEntityState.new()
				var result = entity_state.from_bytes(msg_bytes) # TODO: check for errors
				#TODO: debug prints, delete when message is working correctly
				print("ENTITY ID: ", entity_state.get_entityId())
				print("ENTITY POS X : ", entity_state.get_position().get_x())
				print("ENTITY POS Y : ", entity_state.get_position().get_y())
				var entity_position = entity_state.get_position()
				update_other_player_pos.emit(entity_state.get_entityId(), Vector2(entity_position.get_x(), entity_position.get_y()))

			PBServerMetadata.PBServerMessageType.PBPlayerMessage:
				var player_message = PBServerPlayerMessage.PBPlayerMessage.new()
				var result = player_message.from_bytes(msg_bytes) # TODO: check for errors
				var username = player_message.get_entityId()
				var content = player_message.get_content()
				update_content.emit(username, content)
			
			#"NEW_PLAYER":
			#	var id = int(msg[1])
			#	var position = Vector2(float(msg[2]), float(msg[3]))
			#	create_other_player.emit(id, position)
			
			#"OTHER_PLAYER_POS":
			#	var id = int(msg[1])
			#	var position = Vector2(float(msg[2]), float(msg[3]))
			#	print(id, position)
			#	update_other_player_pos.emit(id, position)


func init_pos(username):
	var player_init = PBPlayerInit.PBPlayerInit.new()
	player_init.set_username(username)
	var player_init_bytes = player_init.to_bytes()
	
	send_protocol_buffer(player_init_bytes, PBClientMetadata.PBClientMessageType.PBPlayerInit)
	
	
func _on_player_change_velocity(vel):
	var player_velocity = PBPlayerVelocity.PBPlayerVelocity.new()
	player_velocity.set_x(vel.x)
	player_velocity.set_y(vel.y)
	var player_velocity_bytes = player_velocity.to_bytes()
	print("sending velocity")
	
	send_protocol_buffer(player_velocity_bytes, PBClientMetadata.PBClientMessageType.PBPlayerVelocity)
	
func _on_chatbox_send_message(message):
	var player_message = PBClientPlayerMessage.PBPlayerMessage.new()
	player_message.set_content(message)
	var player_message_bytes = player_message.to_bytes()
	send_protocol_buffer(player_message_bytes, PBClientMetadata.PBClientMessageType.PBPlayerMessage)
	
func send_protocol_buffer(msg_bytes, type):
	var metadata = PBClientMetadata.PBClientMetadata.new()
	metadata.set_type(type)
	metadata.set_length(msg_bytes.size())
	
	var metadata_bytes = metadata.to_bytes()
	var metadata_size_bytes = int_to_big_endian_bytes(metadata_bytes.size())
	var frame_size_bytes = int_to_big_endian_bytes(msg_bytes.size() + metadata_bytes.size() + 4)
	
	socket.put_data(frame_size_bytes + metadata_size_bytes + metadata_bytes + msg_bytes)	
	
	
func int_to_big_endian_bytes(value: int) -> PackedByteArray:
	var buffer = PackedByteArray()

	# Pack the integer into a buffer using big-endian format
	buffer.resize(4)
	buffer[0] = (value >> 24) & 0xFF
	buffer[1] = (value >> 16) & 0xFF
	buffer[2] = (value >> 8) & 0xFF
	buffer[3] = value & 0xFF

	return buffer
	
func big_endian_bytes_to_int(bytes: PackedByteArray) -> int:
	var integer_value : int = (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3]
	return integer_value


func _on_login_init_tcp_peer(username):
	init_pos(username)
