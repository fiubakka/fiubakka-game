class_name TrucoLastPlayDto extends Node

enum TYPES { NONE, CARD, SHOUT }

var type: TYPES
var card_id: int = -1
var shout_id: int = -1


func _init(_type: TYPES, _card_id: int, _shout_id: int) -> void:
	type = _type
	card_id = _card_id
	shout_id = _shout_id
