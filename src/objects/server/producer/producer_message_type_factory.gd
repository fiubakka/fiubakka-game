extends Object

const PBClientMessageType = (
	preload("res://src/protocol/compiled/client/metadata.gd").PBClientMessageType
)

const PBPlayerInit = preload("res://src/protocol/compiled/client/init/player_init.gd").PBPlayerInit
const PBPlayerMovement = (
	preload("res://src/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)
const PBPlayerMessage = (
	preload("res://src/protocol/compiled/client/chat/message.gd").PBPlayerMessage
)

static var _MESSAGE_TYPE_MAP := {
	"PBPlayerInit": PBClientMessageType.PBPlayerInit,
	"PBPlayerMovement": PBClientMessageType.PBPlayerMovement,
	"PBPlayerMessage": PBClientMessageType.PBPlayerMessage
}


static func from(message: Object) -> Result:
	var message_type: int = _MESSAGE_TYPE_MAP.get(message.get_class())
	if message_type == null:
		printerr("Unknown message type for message class: " + message.get_class())
		return Result.err(ERR_CANT_RESOLVE)
	return Result.ok(message_type)
