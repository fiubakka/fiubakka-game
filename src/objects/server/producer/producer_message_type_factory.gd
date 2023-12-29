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


static func from(message: Object) -> Result:
	var type: PBClientMessageType
	if message is PBPlayerInit:
		type = PBClientMessageType.PBPlayerInit
	elif message is PBPlayerMovement:
		type = PBClientMessageType.PBPlayerMovement
	elif message is PBPlayerMessage:
		type = PBClientMessageType.PBPlayerMessage

	if type == null:
		printerr("Unknown message type for message class: " + message.get_class())
		return Result.err(ERR_CANT_RESOLVE)
	return Result.ok(type)
