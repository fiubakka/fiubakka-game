extends Control

var drop_zones := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_zones.append($HBoxContainer/CenterContainer/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer2/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer3/Control/DropZone)


