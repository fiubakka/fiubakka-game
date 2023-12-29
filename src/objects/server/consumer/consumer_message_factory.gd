extends Object

const PBServerMessageType = (
	preload("res://addons/protocol/compiled/server/metadata.gd").PBServerMessageType
)
const PBGameEntityState = (
	preload("res://addons/protocol/compiled/server/state/game_entity_state.gd").PBGameEntityState
)
const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/server/chat/message.gd").PBPlayerMessage
)
const PBPlayerInitReady = (
	preload("res://addons/protocol/compiled/server/init/player_init_ready.gd").PBPlayerInitReady
)

static var _MESSAGE_MAP := {
	PBServerMessageType.PBGameEntityState: PBGameEntityState,
	PBServerMessageType.PBPlayerMessage: PBPlayerMessage,
	PBServerMessageType.PBPlayerInitReady: PBPlayerInitReady,
}


static func from(type: PBServerMessageType, data: PackedByteArray) -> Result:
	var message_constructor: Object = _MESSAGE_MAP.get(type)
	if message_constructor == null:
		printerr("Unknown message type: ", type)
		return Result.err(ERR_CANT_RESOLVE)
	var message: Object = message_constructor.new()
	if message.from_bytes(data) != OK:
		printerr("Failed to parse message of type: ", type)
		return Result.err(ERR_PARSE_ERROR)
	return Result.ok(message)
