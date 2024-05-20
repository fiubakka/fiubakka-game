extends Node

const MAPS_LIST := [
	"res://src/scenes/maps/main_hall/main_hall.tscn",
	"res://src/scenes/maps/room_200/room_200.tscn",
	"res://src/scenes/maps/central_hall/central_hall.tscn",
	"res://src/scenes/maps/comedor/comedor.tscn"
]

const MAP_LIMITS := [
	{"w": 2208, "h": 876}, {"w": 672, "h": 768}, {"w": 1920, "h": 1872}, {"w": 768, "h": 672}
]


func id_to_content_path(new_level_id: int) -> String:
	return MAPS_LIST[new_level_id]


func content_path_to_id(new_level_content_path: String) -> int:
	return MAPS_LIST.find(new_level_content_path)
