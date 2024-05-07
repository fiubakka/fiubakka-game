extends Node

var player_name := ""

var is_playing_truco := false

var player_customization := {
	"body": 0, "hair": 2, "eyes": 2, "outfit": 2, "facial_hair": 2, "glasses": 2, "hats": 2
}


func from_equipment(equipment: Equipment) -> Dictionary:
	return {
		"body": equipment.body,
		"hair": equipment.hair,
		"eyes": equipment.eyes,
		"outfit": equipment.outfit,
		"facial_hair": equipment.facial_hair,
		"glasses": equipment.glasses,
		"hats": equipment.hat
	}
