extends Object

const PBClientMetadata = preload("res://src/protocol/compiled/client/metadata.gd").PBClientMetadata
const PBClientMessageType = (
	preload("res://src/protocol/compiled/client/metadata.gd").PBClientMessageType
)

const PBPlayerInit = preload("res://src/protocol/compiled/client/init/player_init.gd").PBPlayerInit
const PBPlayerMovement = (
	preload("res://src/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)

var conn: StreamPeerTCP


func stop() -> void:
	pass


func start(connection: StreamPeerTCP) -> void:
	conn = connection
	_on_login_init_player("marktheman")


func send(data: PackedByteArray, type: PBClientMessageType) -> void:
	var metadata := PBClientMetadata.new()
	metadata.set_type(type)
	metadata.set_length(data.size())

	var metadata_bytes := metadata.to_bytes()
	var metadata_size_bytes := _to_big_endian_bytes(metadata_bytes.size())
	var frame_size_bytes := _to_big_endian_bytes(data.size() + metadata_bytes.size() + 4)

	conn.put_data(frame_size_bytes + metadata_size_bytes + metadata_bytes + data)


func _to_big_endian_bytes(value: int) -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(4)
	buffer[0] = (value >> 24) & 0xFF
	buffer[1] = (value >> 16) & 0xFF
	buffer[2] = (value >> 8) & 0xFF
	buffer[3] = value & 0xFF
	return buffer


######## HANDLERS ########


func _on_login_init_player(username: String) -> void:
	var player_init := PBPlayerInit.new()
	player_init.set_username(username)
	send(player_init.to_bytes(), PBClientMessageType.PBPlayerInit)


func _on_player_movement(velocity: Vector2, position: Vector2) -> void:
	var player_movement := PBPlayerMovement.new()
	var player_velocity := player_movement.new_velocity()
	var player_position := player_movement.new_position()
	player_velocity.set_x(velocity.x)
	player_velocity.set_y(velocity.y)
	player_position.set_x(position.x)
	player_position.set_y(position.y)
	send(player_movement.to_bytes(), PBClientMessageType.PBPlayerMovement)
