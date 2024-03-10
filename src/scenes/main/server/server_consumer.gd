extends Node

signal user_init_ready(position: Vector2, equipment: Equipment, mapId: int)  #TOOD: Tipar esto
signal update_entity_state(
	entityId: String, position: Vector2, velocity: Vector2, equipment: Equipment
)
signal update_content(entityId: String, content: String)
signal player_changed_map

const Consumer = preload("res://src/objects/server/consumer/consumer.gd")

const PBGameEntityState = (
	preload("res://addons/protocol/compiled/server/state/game_entity_state.gd").PBGameEntityState
)
const PBPlayerInitSuccess = (
	preload("res://addons/protocol/compiled/server/init/player_init.gd").PBPlayerInitSuccess
)

const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/server/chat/message.gd").PBPlayerMessage
)

const PBPlayerChangeMapReady = (
	preload("res://addons/protocol/compiled/server/map/change_map_ready.gd").PBPlayerChangeMapReady
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
	elif message is PBPlayerMessage:
		handler = "_handle_player_message"
	elif message is PBPlayerChangeMapReady:
		handler = "_handle_player_change_map_ready"

	call_deferred(handler, message)


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
	update_entity_state.emit(
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
