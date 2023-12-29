extends Object

const PBServerMetadata = (
	preload("res://addons/protocol/compiled/server/metadata.gd").PBServerMetadata
)

const ConsumerMessageFactory = preload(
	"res://src/objects/server/consumer/consumer_message_factory.gd"
)

const MESSAGE_LEN_SIZE = 4
const METADATA_LEN_SIZE = 4

var _conn: StreamPeerTCP


func _init(connection: StreamPeerTCP) -> void:
	_conn = connection


func read_message() -> Result:
	var message_len := _conn.get_data(MESSAGE_LEN_SIZE)
	if message_len[0] != OK:
		printerr("Error reading message length, skipping")
		return Result.err(message_len[0])
	var message := _conn.get_data(_from_big_endian_bytes(message_len[1]))
	if message[0] != OK:
		printerr("Error reading message, skipping")
		return Result.err(message[0])

	var metadata_len := _from_big_endian_bytes(message[1].slice(0, METADATA_LEN_SIZE))
	var metadata_bytes: PackedByteArray = message[1].slice(
		METADATA_LEN_SIZE, METADATA_LEN_SIZE + metadata_len
	)

	var metadata := PBServerMetadata.new()
	var metadata_result := metadata.from_bytes(metadata_bytes)
	if metadata_result != OK:
		printerr("Error parsing metadata, skipping")
		return Result.err(metadata_result)

	var content_bytes: PackedByteArray = message[1].slice(METADATA_LEN_SIZE + metadata_len)
	var content := ConsumerMessageFactory.from(metadata.get_type(), content_bytes)
	if content.is_err():
		printerr("Error parsing content, skipping")
		return content

	return Result.ok(content.get_value())


func _from_big_endian_bytes(bytes: PackedByteArray) -> int:
	return (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3]
