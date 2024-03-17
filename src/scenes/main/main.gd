extends Node2D

const LoginScene = preload("res://src/scenes/login/login.tscn")
const CharCreationScene = preload("res://src/scenes/character_creation/character_creation.tscn")
const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const main_hall_path = "res://src/scenes/maps/main_hall/main_hall.tscn"

const MILISECONDS_UNTIL_DISCONNECT = 15000

# var entities: Dictionary = {}
var is_game_paused: bool = false

signal login_ready
signal chat_opened
signal chat_closed
signal paused
signal unpaused
signal ui_opened(open: bool)


func _process(_delta: float) -> void:
	pass


func _on_server_consumer_user_init_ready(
	_position: Vector2, equipment: Equipment, mapId: int
) -> void:
	var map_content_path := MapsDictionary.id_to_content_path(mapId)
	SceneManager.load_new_scene(map_content_path)
	#TODO: Is it okay to change the initial position of the player like this or should we use something else
	# like signals for example?
	await SceneManager.transition_finished
	var player: Player = get_tree().current_scene.get_node("Player")
	var producer_movement_signal_handler: Callable = (
		$ServerConnection/ServerProducer._on_player_movement
	)
	if !player.update_movement.is_connected(producer_movement_signal_handler):
		player.update_movement.connect(producer_movement_signal_handler)
	player.set_equipment(equipment)
	player.position = _position
	var current_level := get_tree().current_scene
	current_level.data["player_equipment"] = equipment
	current_level.enter_level()
	login_ready.emit()
	$Login.queue_free()

	$GUI/GuiManager.set_process(true)
	ui_opened.connect(player._on_main_ui_opened)


func _on_server_consumer_update_entity_state(
	entityId: String, entityPosition: Vector2, entityVelocity: Vector2, equipment: Equipment
) -> void:
	EntityManager.update_entity_state(entityId, entityPosition, entityVelocity, equipment)


func _on_pause_unpaused() -> void:
	is_game_paused = false
	unpaused.emit()


func _on_register_save_character() -> void:
	$Register.queue_free()


func _on_main_menu_go_to_login() -> void:
	$Login.visible = true
	$MainMenu.visible = false


func _on_main_menu_go_to_register() -> void:
	$Register.visible = true
	$MainMenu.visible = false


func _on_login_return_to_menu() -> void:
	$MainMenu.visible = true
	$Login.visible = false


func _on_register_return_to_menu() -> void:
	$MainMenu.visible = true
	$Register.visible = false


func _on_gui_manager_ui_opened(open: bool) -> void:
	ui_opened.emit(open)
