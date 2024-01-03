extends Node

signal user_init_ready(position: Vector2)
signal update_entity_state(entityId: String, position: Vector2, velocity: Vector2)
signal update_content(entityId: String, content: String)

const Consumer = preload("res://src/objects/server/consumer/consumer.gd")

const PBGameEntityState = (
	preload("res://addons/protocol/compiled/server/state/game_entity_state.gd").PBGameEntityState
)
const PBPlayerInitReady = (
	preload("res://addons/protocol/compiled/server/init/player_init_ready.gd").PBPlayerInitReady
)

const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/server/chat/message.gd").PBPlayerMessage
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
	elif message is PBPlayerInitReady:
		handler = "_handle_player_init_ready"
	elif message is PBPlayerMessage:
		handler = "_handle_player_message"

	call_deferred(handler, message)


func _handle_player_init_ready(msg: PBPlayerInitReady) -> void:
	user_init_ready.emit(
		Vector2(
			msg.get_initialState().get_position().get_x(),
			msg.get_initialState().get_position().get_y()
		)
	)


func _handle_game_entity_state(msg: PBGameEntityState) -> void:
	(
		update_entity_state
		. emit(
			msg.get_entityId(),
			Vector2(msg.get_position().get_x(), msg.get_position().get_y()),
			Vector2(msg.get_velocity().get_x(), msg.get_velocity().get_y()),
		)
	)


func _handle_player_message(msg: PBPlayerMessage) -> void:
	(
		update_content
		. emit(
			msg.get_entityId(),
			msg.get_content(),
		)
	)
