extends Object

const PBClientMessageType = (
	preload("res://addons/protocol/compiled/client/metadata.gd").PBClientMessageType
)

const PBPlayerLogin = (
	preload("res://addons/protocol/compiled/client/init/player_login.gd").PBPlayerLogin
)
const PBPlayerRegister = (
	preload("res://addons/protocol/compiled/client/init/player_register.gd").PBPlayerRegister
)
const PBPlayerMovement = (
	preload("res://addons/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)
const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/client/chat/message.gd").PBPlayerMessage
)

const PBPlayerChangeMap = (
	preload("res://addons/protocol/compiled/client/map/change_map.gd").PBPlayerChangeMap
)


static func from(message: Object) -> Result:
	var type: PBClientMessageType
	if message is PBPlayerRegister:
		type = PBClientMessageType.PBPlayerRegister
	elif message is PBPlayerLogin:
		type = PBClientMessageType.PBPlayerLogin
	elif message is PBPlayerMovement:
		type = PBClientMessageType.PBPlayerMovement
	elif message is PBPlayerMessage:
		type = PBClientMessageType.PBPlayerMessage
	elif message is PBPlayerChangeMap:
		type = PBClientMessageType.PBPlayerChangeMap

	if type == null:
		printerr("Unknown message type for message class: " + message.get_class())
		return Result.err(ERR_CANT_RESOLVE)
	return Result.ok(type)
