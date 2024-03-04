extends Node

signal content_finished_loading(content: Node)
signal transition_finished

var loading_screen: LoadingScreen
var loading_screen_scene: PackedScene = preload("res://src/scenes/loading_screen/loading_screen.tscn")
var load_progress_timer: Timer

# private
var _content_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	content_finished_loading.connect(_on_content_finished_loading)

func load_new_scene(content_path: String) -> void:
	loading_screen = loading_screen_scene.instantiate()
	get_tree().root.add_child(loading_screen)
	loading_screen.start_transition()
	load_content(content_path)
	
func load_content(content_path: String) -> void:
	# Load new scene in another thread.
	# This lets us place a loading screen, a progress bar
	# and even handle data sent and received from the Server
	var loader := ResourceLoader.load_threaded_request(content_path)
	if not ResourceLoader.exists(content_path) or loader == null:
		push_error("Error loading scene %s" % content_path)
		return
	
	_content_path = content_path
	load_progress_timer = Timer.new()
	load_progress_timer.wait_time = 0.1
	load_progress_timer.timeout.connect(check_load_status)
	get_tree().root.add_child(load_progress_timer)
	load_progress_timer.start()
	

func check_load_status() -> void:
	var status := ResourceLoader.load_threaded_get_status(_content_path)
	match status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Could not load resource %s" % _content_path)
			load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed loading resource %s" % _content_path)
			load_progress_timer.stop()
			return
		ResourceLoader.THREAD_LOAD_LOADED:
			load_progress_timer.stop()
			load_progress_timer.queue_free()
			content_finished_loading.emit(ResourceLoader.load_threaded_get(_content_path).instantiate())
			
func _on_content_finished_loading(new_scene: Node) -> void:
	var current_scene := get_tree().current_scene
	
	# Level data handoff
	if current_scene is Level and new_scene is Level:
		new_scene.data = current_scene.data
	
	# quickfix for now
	if current_scene.name != "Main":
		current_scene.queue_free()
	
	get_tree().root.call_deferred('add_child', new_scene)
	get_tree().set_deferred('current_scene', new_scene)
	
	if loading_screen != null:
		loading_screen.finish_transition()
		await loading_screen.animation_player.animation_finished
		loading_screen = null
		if new_scene is Level:
			new_scene.enter_level()
	transition_finished.emit()
