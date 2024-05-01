class_name Deck extends Node2D

@export var deck_file := preload("res://art/cards/naipes.png")
var deck_map := {}

enum Ranks {
	ACE = 1, TWO = 2, THREE = 3, FOUR= 4, FIVE = 5, SIX = 6, SEVEN = 7, TEN = 10, ELEVEN = 11, TWELVE = 12
}

# This is the same Enum order as the Server, and should be kept like this
enum Suits {
	CUPS, SWORDS, COINS, CLUBS, BACK
}

const CARD_W := 64
const CARD_H := 96
const GAP := 16
const BACK_X := 944
const BACK_Y := 128


func _ready() -> void:
	# Deck could be just a script file, but we add
	# a node for debugging purposes
	create()


func _init() -> void:
	create()


func create() -> void:
	var x := GAP
	var y := GAP
		
	deck_map[Suits.COINS] = {}
	deck_map[Suits.SWORDS] = {}
	deck_map[Suits.CLUBS] = {}
	deck_map[Suits.CUPS] = {}
	for rank: Ranks in Ranks.values():
		deck_map[Suits.COINS][rank] = Rect2(x, y, CARD_W, CARD_H)
		y += CARD_H + GAP
		deck_map[Suits.SWORDS][rank] = Rect2(x, y, CARD_W, CARD_H)
		y += CARD_H + GAP
		deck_map[Suits.CLUBS][rank] = Rect2(x, y, CARD_W, CARD_H)
		y += CARD_H + GAP
		deck_map[Suits.CUPS][rank] = Rect2(x, y, CARD_W, CARD_H)
		
		x += CARD_W + GAP
		y = GAP
	deck_map[Suits.BACK] = Rect2(BACK_X, BACK_Y, CARD_W, CARD_H)


func deal(rank: Ranks, suit: Suits) -> Rect2:
	if suit == Suits.BACK:
		return deck_map[suit]
	return deck_map[suit][rank]
