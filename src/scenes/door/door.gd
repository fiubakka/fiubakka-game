class_name Door extends Area2D

signal player_entered_door
@export var path_to_new_scene: String

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player_entered_door.emit(self)
	SceneManager.load_new_scene(path_to_new_scene)
	queue_free()
	#body.set_warpable_to(true, "Room200")
		
