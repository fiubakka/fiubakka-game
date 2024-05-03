extends Node

signal user_init_ready(position: Vector2, equipment: Equipment, mapId: int)
signal update_content(entityId: String, content: String)
signal player_changed_map
signal truco_challenge_received(opponentId: String)
signal allow_truco_play(playId: int, type: PBTrucoPlayTypeEnum)
signal truco_play_card(
	play_id: int,
	suit: int,
	rank: int,
	cards: Array[Card],
	game_over: bool,
	match_over: bool,
	first_points: int,
	second_points: int
)
signal truco_play_update(
	playId: int,
	cards: Array[Card],
	game_over: bool,
	match_over: bool,
	first_points: int,
	second_points: int
)
signal truco_available_shouts(
	isPlayCardAvailable: bool,
	available_shouts: Array
)

const Consumer = preload("res://src/objects/server/consumer/consumer.gd")

const PBGameEntityState = (
	preload("res://addons/protocol/compiled/server/state/game_entity_state.gd").PBGameEntityState
)
const PBPlayerInitSuccess = (
	preload("res://addons/protocol/compiled/server/init/player_init.gd").PBPlayerInitSuccess
)
const PBPlayerInitError = (
	preload("res://addons/protocol/compiled/server/init/player_init.gd").PBPlayerInitError
)

const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/server/chat/message.gd").PBPlayerMessage
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

const PBTrucoPlayTypeEnum = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoPlayType
)

const PBTrucoCard = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoCard
)

const PBTrucoCardSuit = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoCardSuit
)

const PBTrucoNextPlay = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoNextPlay
)

const PBTrucoShout = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoShout
)


var _thread: Thread
var _consumer: Consumer
var _keep_running := true


func start(consumer: Consumer) -> void:
	_consumer = consumer
	_thread = Thread.new()
	_thread.start(_run)


func stop() -> void:
	_keep_running = false
	_thread.wait_to_finish()


func _run() -> void:
	while _keep_running:
		var message := _consumer.read_message()
		if message.is_err():
			print("Error reading message: ", message.get_err())
			continue
		_handle_message(message.get_value())


# Should always be an instance of a PB class
func _handle_message(message: Object) -> void:
	var handler: String
	if message is PBGameEntityState:
		handler = "_handle_game_entity_state"
	elif message is PBPlayerInitSuccess:
		handler = "_handle_player_init_ready"
	elif message is PBPlayerInitError:
		handler = "_handle_player_init_failure"
	elif message is PBPlayerMessage:
		handler = "_handle_player_message"
	elif message is PBPlayerChangeMapReady:
		handler = "_handle_player_change_map_ready"
	elif message is PBGameEntityDisconnect:
		handler = "_handle_game_entity_disconnect"
	elif message is PBTrucoMatchChallengeRequest:
		handler = "_handle_truco_match_challenge_request"
	elif message is PBTrucoMatchChallengeDenied:
		handler = "_handle_truco_match_challenge_denied"
	elif message is PBTrucoAllowPlay:
		handler = "_handle_truco_allow_play"
	elif message is PBTrucoPlay:
		handler = "_handle_truco_play"

	call_deferred(handler, message)


func _handle_player_init_failure(msg: PBPlayerInitError) -> void:
	var login := get_tree().current_scene.get_node("Login")
	if login.visible:
		login.show_error_message(msg.get_error_code())
	else:
		var register := get_tree().current_scene.get_node("Register")
		register.show_error_message(msg.get_error_code())


func _handle_player_init_ready(msg: PBPlayerInitSuccess) -> void:
	var equipment := Equipment.new()
	equipment.set_equipment(
		msg.get_initialState().get_equipment().get_hat(),
		msg.get_initialState().get_equipment().get_hair(),
		msg.get_initialState().get_equipment().get_eyes(),
		msg.get_initialState().get_equipment().get_glasses(),
		msg.get_initialState().get_equipment().get_facial_hair(),
		msg.get_initialState().get_equipment().get_body(),
		msg.get_initialState().get_equipment().get_outfit()
	)
	user_init_ready.emit(
		Vector2(
			msg.get_initialState().get_position().get_x(),
			msg.get_initialState().get_position().get_y()
		),
		equipment,
		msg.get_initialState().get_mapId()
	)


func _handle_game_entity_state(msg: PBGameEntityState) -> void:
	var equipment := Equipment.new()
	(
		equipment
		. set_equipment(
			msg.get_equipment().get_hat(),
			msg.get_equipment().get_hair(),
			msg.get_equipment().get_eyes(),
			msg.get_equipment().get_glasses(),
			msg.get_equipment().get_facial_hair(),
			msg.get_equipment().get_body(),
			msg.get_equipment().get_outfit(),
		)
	)
	EntityManager.update_entity_state(
		msg.get_entityId(),
		Vector2(msg.get_position().get_x(), msg.get_position().get_y()),
		Vector2(msg.get_velocity().get_x(), msg.get_velocity().get_y()),
		equipment
	)


func _handle_player_message(msg: PBPlayerMessage) -> void:
	(
		update_content
		. emit(
			msg.get_entityId(),
			msg.get_content(),
		)
	)


func _handle_player_change_map_ready(msg: PBPlayerChangeMapReady) -> void:
	var new_map_id := msg.get_new_map_id()
	SceneManager.player_change_map_ready(new_map_id)
	player_changed_map.emit()


func _handle_game_entity_disconnect(msg: PBGameEntityDisconnect) -> void:
	var entityId := msg.get_entityId()
	EntityManager.remove_entity(entityId)


func _handle_truco_match_challenge_request(msg: PBTrucoMatchChallengeRequest) -> void:
	truco_challenge_received.emit(msg.get_opponent_username())


func _handle_truco_match_challenge_denied(msg: PBTrucoMatchChallengeDenied) -> void:
	print("Truco match was denied")
	pass  #TODO: handle match denied properly


func _handle_truco_allow_play(msg: PBTrucoAllowPlay) -> void:
	var play_id := msg.get_playId()
	allow_truco_play.emit(play_id)


func _handle_truco_play(msg: PBTrucoPlay) -> void:
	var play_id := msg.get_playId()
	var first_points := msg.get_firstPlayerPoints().get_points()
	var second_points := msg.get_secondPlayerPoints().get_points()

	var truco_manager := get_node("/root/TrucoManager")
	if play_id == 0 and not truco_manager:
		# If we are already loading the Truco scene, ignore new play_id 0 messages
		if SceneManager.is_loading_scene:
			return
		SceneManager.load_new_scene("res://src/scenes/truco/truco_manager.tscn")
		SceneManager._load_content("res://src/scenes/truco/truco_manager.tscn")
		await SceneManager.transition_finished
	
	var play_type: PBTrucoPlayTypeEnum = msg.get_playType()
	
	#var available_shouts := _parse_shouts(msg)
	var next_play_info: PBTrucoNextPlay = msg.get_nextPlayInfo()
	var available_shouts: Array = next_play_info.get_availableShouts()
	truco_available_shouts.emit(
		msg.get_nextPlayInfo().get_isPlayCardAvailable(),
		available_shouts
	)
	
	match play_type:
		PBTrucoPlayTypeEnum.CARD:
			var card := msg.get_card()
			var card_id := card.get_cardId()
			var rank := card.get_number()
			var suit: PBTrucoCardSuit = card.get_suit()
			var game_over := msg.get_isGameOver()
			var match_over := msg.get_isMatchOver()
			var player_cards := _parse_player_cards(msg)
			truco_play_card.emit(
				play_id, suit, rank, player_cards, game_over, match_over, first_points, second_points
			)
		PBTrucoPlayTypeEnum.SHOUT:
			print("got shout")
			var player_cards := _parse_player_cards(msg)
			# do this for now but change signal later
			truco_play_update.emit(play_id, player_cards)
		PBTrucoPlayTypeEnum.UPDATE:
			var game_over := msg.get_isGameOver()
			var match_over := msg.get_isMatchOver()
			var player_cards := _parse_player_cards(msg)
			truco_play_update.emit(play_id, player_cards, game_over, match_over, first_points, second_points)


func _parse_player_cards(msg: PBTrucoPlay) -> Array[Card]:
	var cards: Array = msg.get_playerCards()
	var player_cards: Array[Card] = []
	var deck := Deck.new()
	for card: PBTrucoCard in cards:
		var card_id := card.get_cardId()
		var rank := card.get_number()
		var suit: PBTrucoCardSuit = card.get_suit()
		
		var player_card := Card.new()
		player_card.id = card_id
		player_card.texture = deck.deck_file
		player_card.region_enabled = true
		player_card.region_rect = deck.deal(rank, suit as Deck.Suits)
		player_card.suit = suit
		player_card.rank = rank
		player_cards.append(player_card)
	return player_cards

#func _parse_shouts(msg: PBTrucoPlay) -> Dictionary:
	#var next_play_info: PBTrucoNextPlay = msg.get_nextPlayInfo()
	#var available_shouts: Array = next_play_info.get_availableShouts()
	#
	#const shouts_names = {
		#PBTrucoShout.ENVIDO: "ENVIDO",
		#PBTrucoShout.TRUCO: "TRUCO",
	#}
	#
	#const shouts_aswers_names = {
		#PBTrucoShout.REAL_ENVIDO: "REAL_ENVIDO",
		#PBTrucoShout.FALTA_ENVIDO: "FALTA_ENVIDO",
		#PBTrucoShout.ENVIDO_QUIERO: "ENVIDO_QUIERO",
		#PBTrucoShout.ENVIDO_NO_QUIERO: "ENVIDO_NO_QUIERO",
		#PBTrucoShout.RETRUCO: "RETRUCO",
		#PBTrucoShout.VALE_CUATRO: "VALE_CUATRO",
		#PBTrucoShout.TRUCO_QUIERO: "TRUCO_QUIERO",
		#PBTrucoShout.TRUCO_NO_QUIERO: "TRUCO_NO_QUIERO"
	#}
	#
	#var parsed_shouts := []
	#var parsed_shout_answers := []
	#for shout: int in available_shouts:
		#if shout in shouts_names:
			#parsed_shouts.append(shouts_names[shout])
		#elif shout in shouts_aswers_names:
			#parsed_shout_answers.append(shouts_aswers_names[shout])
#
	#var shouts := {
		#"shouts": parsed_shouts,
		#"shout_answers": parsed_shout_answers
	#}
	#
	#return shouts

func _parse_shouts(msg: PBTrucoPlay) -> Dictionary:
	var next_play_info: PBTrucoNextPlay = msg.get_nextPlayInfo()
	var available_shouts: Array = next_play_info.get_availableShouts()
	
	const shouts_names = {
		PBTrucoShout.ENVIDO: "ENVIDO",
		PBTrucoShout.TRUCO: "TRUCO",
	}
	
	const shouts_aswers_names = {
		PBTrucoShout.REAL_ENVIDO: "REAL_ENVIDO",
		PBTrucoShout.FALTA_ENVIDO: "FALTA_ENVIDO",
		PBTrucoShout.ENVIDO_QUIERO: "ENVIDO_QUIERO",
		PBTrucoShout.ENVIDO_NO_QUIERO: "ENVIDO_NO_QUIERO",
		PBTrucoShout.RETRUCO: "RETRUCO",
		PBTrucoShout.VALE_CUATRO: "VALE_CUATRO",
		PBTrucoShout.TRUCO_QUIERO: "TRUCO_QUIERO",
		PBTrucoShout.TRUCO_NO_QUIERO: "TRUCO_NO_QUIERO"
	}
	
	var parsed_shouts := []
	var parsed_shout_answers := []
	for shout: int in available_shouts:
		if shout in shouts_names:
			parsed_shouts.append(shouts_names[shout])
		elif shout in shouts_aswers_names:
			parsed_shout_answers.append(shouts_aswers_names[shout])

	var shouts := {
		"shouts": parsed_shouts,
		"shout_answers": parsed_shout_answers
	}
	
	return shouts
