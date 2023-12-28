extends Node

signal update_entity_state(entityId: String, position: Vector2, velocity: Vector2)

const Consumer = preload("res://src/objects/server/consumer/consumer.gd")

const PBGameEntityState = (
	preload("res://src/protocol/compiled/server/state/game_entity_state.gd").PBGameEntityState
)
const PBPlayerInitReady = (
	preload("res://src/protocol/compiled/server/init/player_init_ready.gd").PBPlayerInitReady
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
			print("Error reading message: ", message.get_error())
			continue
		_handle_message(message.get_value())


# Should always be an instance of a PB class
func _handle_message(message: Object) -> void:
	if message is PBGameEntityState:
		var msg := message as PBGameEntityState
		(
			update_entity_state  # TODO use call_deferred
			. emit(
				msg.get_entityId(),
				Vector2(msg.get_position().get_x(), msg.get_position().get_y()),
				Vector2(msg.get_velocity().get_x(), msg.get_velocity().get_y()),
			)
		)
	elif message is PBPlayerInitReady:
		var msg := message as PBPlayerInitReady
		print("PLAYER READY WITH STATE: ", msg.get_initialState())
