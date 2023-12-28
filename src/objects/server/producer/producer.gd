extends Object

const PBClientMetadata = preload("res://src/protocol/compiled/client/metadata.gd").PBClientMetadata
const PBClientMessageType = (
	preload("res://src/protocol/compiled/client/metadata.gd").PBClientMessageType
)

const ProducerMessageTypeFactory = preload(
	"res://src/objects/server/producer/producer_message_type_factory.gd"
)

const MESSAGE_LEN_SIZE = 4

var _conn: StreamPeerTCP


func _init(connection: StreamPeerTCP) -> void:
	_conn = connection


func send(message: Object) -> Result:
	var data: PackedByteArray = message.to_bytes()
	var metadata := PBClientMetadata.new()
	var type := ProducerMessageTypeFactory.from(message)
	if type.is_err():
		printerr("Failed to get message type for produced message: ", type.get_err())
		return type
	metadata.set_type(type.get_value())
	metadata.set_length(data.size())

	var metadata_bytes := metadata.to_bytes()
	var metadata_size_bytes := _to_big_endian_bytes(metadata_bytes.size())
	var frame_size_bytes := _to_big_endian_bytes(
		data.size() + metadata_bytes.size() + MESSAGE_LEN_SIZE
	)

	_conn.put_data(frame_size_bytes + metadata_size_bytes + metadata_bytes + data)

	return Result.ok(null)


func _to_big_endian_bytes(value: int) -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(4)
	buffer[0] = (value >> 24) & 0xFF
	buffer[1] = (value >> 16) & 0xFF
	buffer[2] = (value >> 8) & 0xFF
	buffer[3] = value & 0xFF
	return buffer
