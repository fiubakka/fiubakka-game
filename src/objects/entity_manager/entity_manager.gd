extends Node

signal add_entity(entity: Entity)

const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const MILISECONDS_UNTIL_DISCONNECT = 15000

var delete_entities_timer: Timer

# private
var entities: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delete_entities_timer = Timer.new()
	delete_entities_timer.timeout.connect(Callable(self, "_delete_entities"))
	add_child(delete_entities_timer)
	delete_entities_timer.set_wait_time(10.0)
	delete_entities_timer.start()


func _delete_entities() -> void:
	var curr_time := Time.get_ticks_msec()
	for entityId: String in entities:
		#If we dont get an update in 15s we consider that player disconnected and delete it
		if curr_time - entities[entityId].last_update > MILISECONDS_UNTIL_DISCONNECT:
			entities[entityId].queue_free()
			entities.erase(entityId)


func update_entity_state(
	entityId: String, entityPosition: Vector2, entityVelocity: Vector2, equipment: Equipment
) -> void:
	if SceneManager.is_loading_scene:
		await SceneManager.transition_finished
	if entities.has(entityId):
		var entity: Node = entities[entityId]
		entity.last_update = Time.get_ticks_msec()
		entity.add_movement_update(entityPosition, entityVelocity)
		if !Equipment.compare_equipment(entity.equipment, equipment):
			entity.set_equipment(equipment)
	else:
		var entity := EntityScene.instantiate()
		entity.last_update = Time.get_ticks_msec()
		entity.id = entityId
		entity.position = entityPosition
		entity.velocity = entityVelocity
		entity.player_name = entityId
		entity.set_equipment(equipment)
		entities[entityId] = entity
		add_entity.emit(entity)


func empty_entities() -> void:
	entities = {}


func remove_entity(other_player_id: String) -> void:
	entities[other_player_id].queue_free()
	entities.erase(other_player_id)
