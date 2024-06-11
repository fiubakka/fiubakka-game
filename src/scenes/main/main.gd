extends Node2D

const LoginScene = preload("res://src/scenes/login/login.tscn")
const CharCreationScene = preload("res://src/scenes/character_creation/character_creation.tscn")
const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const main_hall_path = "res://src/scenes/maps/main_hall/main_hall.tscn"

const MILISECONDS_UNTIL_DISCONNECT = 15000

var is_game_paused: bool = false

signal login_ready


func _process(_delta: float) -> void:
	pass


func _on_server_consumer_user_init_ready(
	_position: Vector2, equipment: Equipment, mapId: int
) -> void:
	var map_content_path := MapsDictionary.id_to_content_path(mapId)
	SceneManager.load_new_scene(map_content_path)
	SceneManager._load_content(map_content_path)
	await SceneManager.transition_finished
	var player: Player = get_tree().current_scene.get_node("Player")
	var producer_movement_signal_handler: Callable = (
		$ServerConnection/ServerProducer._on_player_movement
	)
	if !player.update_movement.is_connected(producer_movement_signal_handler):
		player.update_movement.connect(producer_movement_signal_handler)
	player.set_equipment(equipment)
	player.position = _position
	PlayerInfo.player_customization = PlayerInfo.from_equipment(equipment)
	var current_level := get_tree().current_scene
	current_level.data["player_equipment"] = equipment
	current_level.enter_level()
	login_ready.emit()
	$Login.queue_free()
	$Register.queue_free()

	var audio_player := $AudioStreamPlayer
	audio_player.play()

	$GUI/GuiManager.set_process(true)


func _on_pause_unpaused() -> void:
	$GUI/GuiManager.handle_pause_open()


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
	var player: Player = get_tree().current_scene.get_node("Player")
	if open:
		player.disable()
	else:
		player.enable()


func _on_pause_main_music() -> void:
	var audio_player := $AudioStreamPlayer
	audio_player.stop()
