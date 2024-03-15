class_name Equipment

var hat: int
var hair: int
var eyes: int
var glasses: int
var facial_hair: int
var body: int
var outfit: int


static func compare_equipment(equipment1: Equipment, equipment2: Equipment) -> bool:
	return (
		equipment1.hat == equipment2.hat
		&& equipment1.hair == equipment2.hair
		&& equipment1.eyes == equipment2.eyes
		&& equipment1.facial_hair == equipment2.facial_hair
		&& equipment1.glasses == equipment2.glasses
		&& equipment1.body == equipment2.body
		&& equipment1.outfit == equipment2.outfit
	)


func set_equipment(
	_hat: int, _hair: int, _eyes: int, _glasses: int, _facial_hair: int, _body: int, _outfit: int
) -> void:
	hat = _hat
	hair = _hair
	eyes = _eyes
	glasses = _glasses
	facial_hair = _facial_hair
	body = _body
	outfit = _outfit


func set_hat(_hat: int) -> void:
	hat = _hat


func set_glasses(_glasses: int) -> void:
	glasses = _glasses


func set_hair(_hair: int) -> void:
	hair = _hair


func set_facial_hair(_facial_hair: int) -> void:
	facial_hair = _facial_hair


func set_outfit(_outfit: int) -> void:
	outfit = _outfit
