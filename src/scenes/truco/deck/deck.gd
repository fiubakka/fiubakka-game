class_name Deck extends Node2D

@export var deck_file := preload("res://art/cards/naipes.png")
var deck_map := {}

enum Ranks {
	ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, TEN, ELEVEN, TWELVE
}

enum Suits {
	GOLD, SWORDS, CLUBS, CUPS 
}

const CARD_W = 64
const CARD_H = 96
const GAP := 16

func _ready() -> void:
	# Deck could be just a script file, but we add
	# a node for debugging purposes
	create()

func _init() -> void:
	create()
	
func create() -> void:
	var x := GAP
	var y := GAP
	for suit: Suits in Suits.values():
		if not deck_map.has(suit):
				deck_map[suit] = {}
		for rank: Ranks in Ranks.values():
			deck_map[suit][rank] = Rect2(x, y, CARD_W, CARD_H)
			x += CARD_W + GAP
		y += CARD_H + GAP
		x = GAP

func deal(rank: Ranks, suit: Suits) -> Rect2:
	return deck_map[suit][rank]
