class_name Door extends Area2D

signal player_entered_door
signal player_changes_level(level: int)

@export var path_to_new_scene: String
var timer: Timer


func _ready() -> void:
	get_node("/root/Main/ServerConnection/ServerConsumer").player_changed_map.connect(
		self._on_player_change_map_ready
	)


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player_entered_door.emit(body)
	timer = Timer.new()  #This timer is to send the change map message until we get a response from the server
	var level_id := MapsDictionary.content_path_to_id(path_to_new_scene)
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(level_id))
	add_child(timer)
	timer.start()
	timer.set_wait_time(2.0)


func _on_area_entered(area: Area2D) -> void:
	var entity := area.get_parent() as Node2D
	if not entity is Entity:
		return
	get_node("/root/Main").remove_entity(entity.id)
	entity.queue_free()


func _on_timer_timeout(level_id: int) -> void:
	# Server producer and consumer are nested in Main
	# TODO: change them to a singleton (autoload) to avoid fetching a node like this
	var producer := get_node("/root/Main/ServerConnection/ServerProducer")
	producer._on_player_changes_level(level_id)


func _on_player_change_map_ready() -> void:
	queue_free()
