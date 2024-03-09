extends Node

class_name InventoryCatalogue

var cs := CompositeSprites

const inventory_catalogue := {
	"0": {
		"id": 0,
		"name": "Hat 0",
		"description": "A hat",
		"type": "hat",
		"equippable": true,
		"texture": cs.hats_spritesheet[1]
	}
}

