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
const PBPlayerInitSuccess = (
	preload("res://addons/protocol/compiled/server/init/player_init.gd").PBPlayerInitSuccess
)
const PBPlayerInitError = (
	preload("res://addons/protocol/compiled/server/init/player_init.gd").PBPlayerInitError
)
const PBPlayerChangeMapReady = (
	preload("res://addons/protocol/compiled/server/map/change_map_ready.gd").PBPlayerChangeMapReady
)
const PBGameEntityDisconnect = (
	preload("res://addons/protocol/compiled/server/state/game_entity_disconnect.gd")
	. PBGameEntityDisconnect
)

const PBTrucoMatchChallengeRequest = (
	preload("res://addons/protocol/compiled/server/truco/match_challenge_request.gd")
	. PBTrucoMatchChallengeRequest
)

const PBTrucoMatchChallengeDenied = (
	preload("res://addons/protocol/compiled/server/truco/match_challenge_denied.gd")
	. PBTrucoMatchChallengeDenied
)

const PBTrucoAllowPlay = (
	preload("res://addons/protocol/compiled/server/truco/allow_play.gd").PBTrucoAllowPlay
)

const PBTrucoPlay = preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoPlay

const PBTrucoPlayerDisconnected = (
	preload("res://addons/protocol/compiled/server/truco/player_disconnected.gd").PBTrucoPlayerDisconnected
)

static var _MESSAGE_MAP := {
	PBServerMessageType.PBGameEntityState: PBGameEntityState,
	PBServerMessageType.PBPlayerMessage: PBPlayerMessage,
	PBServerMessageType.PBPlayerInitSuccess: PBPlayerInitSuccess,
	PBServerMessageType.PBPlayerInitError: PBPlayerInitError,
	PBServerMessageType.PBPlayerChangeMapReady: PBPlayerChangeMapReady,
	PBServerMessageType.PBGameEntityDisconnect: PBGameEntityDisconnect,
	PBServerMessageType.PBTrucoMatchChallengeRequest: PBTrucoMatchChallengeRequest,
	PBServerMessageType.PBTrucoMatchChallengeDenied: PBTrucoMatchChallengeDenied,
	PBServerMessageType.PBTrucoAllowPlay: PBTrucoAllowPlay,
	PBServerMessageType.PBTrucoPlay: PBTrucoPlay,
	PBServerMessageType.PBTrucoPlayerDisconnected: PBTrucoPlayerDisconnected
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
