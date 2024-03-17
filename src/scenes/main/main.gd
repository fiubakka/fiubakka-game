extends Node2D

const LoginScene = preload("res://src/scenes/login/login.tscn")
const CharCreationScene = preload("res://src/scenes/character_creation/character_creation.tscn")
const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const main_hall_path = "res://src/scenes/maps/main_hall/main_hall.tscn"

var entities: Dictionary = {}
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
	if SceneManager.is_loading_scene:
		await SceneManager.transition_finished
	if entities.has(entityId):
		var entity: Node = entities[entityId]
		entity.add_movement_update(entityPosition, entityVelocity)
		# TODO handle all player updates inside of the player
		#If equipment is the same we dont need to update it
		if !Equipment.compare_equipment(entity.equipment, equipment):
			entity.set_equipment(equipment)
	else:
		var entity := EntityScene.instantiate()
		entity.id = entityId
		entity.position = entityPosition
		entity.velocity = entityVelocity
		entity.player_name = entityId
		entity.set_equipment(equipment)
		entities[entityId] = entity
		get_tree().current_scene.add_child(entity)


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


func empty_entities() -> void:
	entities = {}


func remove_entity(other_player_id: String) -> void:
	entities.erase(other_player_id)
