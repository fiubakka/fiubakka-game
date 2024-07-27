class_name EntityContainer extends Node2D


func _ready() -> void:
	y_sort_enabled = true
	EntityManager.add_entity.connect(self._on_entity_manager_add_entity)


func _on_entity_manager_add_entity(new_entity: Entity) -> void:
	if new_entity.get_parent() == null:
		add_child(new_entity)
