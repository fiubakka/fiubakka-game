extends Object

const PBServerMetadata = preload("res://src/protocol/compiled/server/metadata.gd")
const PBGameEntityState = preload("res://src/protocol/compiled/server/state/game_entity_state.gd")
const PBPlayerMessage = preload("res://src/protocol/compiled/server/chat/message.gd")
const PBPlayerInitReady = preload("res://src/protocol/compiled/server/init/player_init_ready.gd")

static var MESSAGE_MAP := {
	PBServerMetadata.PBServerMessageType.PBGameEntityState: PBGameEntityState.PBGameEntityState,
	PBServerMetadata.PBServerMessageType.PBPlayerMessage: PBPlayerMessage.PBPlayerMessage,
	PBServerMetadata.PBServerMessageType.PBPlayerInitReady: PBPlayerInitReady.PBPlayerInitReady,
}


static func from(type: PBServerMetadata.PBServerMessageType, data: PackedByteArray) -> Array:
	var message_constructor: Object = MESSAGE_MAP.get(type)
	if message_constructor == null:
		printerr("Unknown message type: ", type)
		return [ERR_CANT_RESOLVE]
	var message = message_constructor.new()
	if message.from_bytes(data) != OK:
		printerr("Failed to parse message of type: ", type)
		return [ERR_PARSE_ERROR]
	return [OK, message]
