extends HBoxContainer

class_name OpponentCards

var cards := 3


func clean() -> void:
	var children := get_children()
	for child: CenterContainer in children:
		child.visible = true
	cards = 3


func play_card() -> void:
	var children := get_children()
	children[cards - 1].visible = false
	cards -= 1
