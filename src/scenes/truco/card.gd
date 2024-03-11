extends Sprite2D

var selected := false
var rest_point: Vector2
var rest_nodes := []


func _ready() -> void:
	rest_nodes = get_tree().get_nodes_in_group("zone")
	rest_point = rest_nodes[0].global_position
	rest_nodes[0].select()


func _on_area_2d_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("left_click"):
		selected = true


func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), delta * 25)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			var shortest_dist := 300
			for child: Node2D in rest_nodes:
				var mouse_position: Vector2 = event.global_position
				var distance := mouse_position.distance_to(child.global_position)
				if distance < shortest_dist:
					child.select()
					rest_point = child.global_position
					shortest_dist = distance
