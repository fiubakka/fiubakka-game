extends Sprite2D

class_name Card

signal get_selected(card: Card)
signal get_unselected

var selected := false
var rest_nodes := []
var current_rest_point: DropZone = null


func _ready() -> void:
	rest_nodes = get_tree().get_nodes_in_group("zone")


func set_current_rest_point(dropzone: DropZone) -> void:
	current_rest_point = dropzone
	current_rest_point.select()
	var current_rest_point_pos := current_rest_point.global_position
	global_position = lerp(global_position, current_rest_point_pos, 0)


func _on_area_2d_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click"):
		get_selected.emit(self)


func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), delta * 25)
	else:
		var current_rest_point_pos := current_rest_point.global_position
		global_position = lerp(global_position, current_rest_point_pos, 10 * delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and selected:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			get_unselected.emit()
			var shortest_dist := 300
			for child: Node2D in rest_nodes:
				if !child.has_card:
					var mouse_position: Vector2 = event.global_position
					var distance := mouse_position.distance_to(child.global_position)
					if distance < shortest_dist:
						current_rest_point.deselect()
						current_rest_point = child
						current_rest_point.select()
						shortest_dist = distance
