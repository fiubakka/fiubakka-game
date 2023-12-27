extends Object

signal update_entity_state

const PBServerMetadata = preload("res://src/protocol/compiled/server/metadata.gd")

const PBGameEntityState = preload("res://src/protocol/compiled/server/state/game_entity_state.gd")

const ServerMessageFactory = preload("res://src/objects/server/server_message_factory.gd")

const MESSAGE_LEN_SIZE = 4
const METADATA_LEN_SIZE = 4

var conn: StreamPeerTCP
var thread: Thread
var keep_running: bool


func _init():
	thread = Thread.new()
	keep_running = true


func start(connection: StreamPeerTCP):
	conn = connection
	thread.start(_run)


func stop():
	keep_running = false
	thread.wait_to_finish()


func _run() -> void:
	while keep_running:
		var message_len := conn.get_data(MESSAGE_LEN_SIZE)
		if message_len[0] != OK:
			printerr("Error reading message length, skipping")
			continue
		var message := conn.get_data(_from_big_endian_bytes(message_len[1]))
		if message[0] != OK:
			printerr("Error reading message, skipping")
			continue

		var metadata_len := _from_big_endian_bytes(message[1].slice(0, METADATA_LEN_SIZE))
		var metadata_bytes: PackedByteArray = message[1].slice(
			METADATA_LEN_SIZE, METADATA_LEN_SIZE + metadata_len
		)

		var metadata := PBServerMetadata.PBServerMetadata.new()
		if metadata.from_bytes(metadata_bytes) != OK:
			printerr("Error parsing metadata, skipping")
			continue

		var content_bytes: PackedByteArray = message[1].slice(METADATA_LEN_SIZE + metadata_len)
		var content := ServerMessageFactory.from(metadata.get_type(), content_bytes)
		if content[0] != OK:
			printerr("Error parsing content, skipping")
			continue
		call_deferred("_handle_message", content[1])


func _from_big_endian_bytes(bytes: PackedByteArray) -> int:
	return (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3]


# Should always be an instance of a PB class
func _handle_message(message: Object):
	if message is PBGameEntityState.PBGameEntityState:
		var msg := message as PBGameEntityState.PBGameEntityState
		(
			update_entity_state
			. emit(
				msg.get_entityId(),
				Vector2(msg.get_position().get_x(), msg.get_position().get_y()),
				Vector2(msg.get_velocity().get_x(), msg.get_velocity().get_y()),
			)
		)
