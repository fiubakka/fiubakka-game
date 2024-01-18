extends Node2D

# TODO: move all of its children into CharacterSprite
# this is to be able to use this node as a singleton in other places and
# preload the sprites

const body_spritesheet = {
	0: preload("res://art/char_creator/body/Body_48x48_01.png"),
	1: preload("res://art/char_creator/body/Body_48x48_02.png"),
}

const hair_spritesheet = {
	0: null,
	1: preload("res://art/char_creator/hairstyle/Hairstyle_01_48x48_01.png"),
	2: preload("res://art/char_creator/hairstyle/Hairstyle_01_48x48_02.png"),
	3: preload("res://art/char_creator/hairstyle/Hairstyle_25_48x48_01.png"),
	4: preload("res://art/char_creator/hairstyle/Hairstyle_25_48x48_02.png"),
}

const eyes_spritesheet = {
	0: preload("res://art/char_creator/eyes/Eyes_48x48_01.png"),
	1: preload("res://art/char_creator/eyes/Eyes_48x48_02.png"),
	2: preload("res://art/char_creator/eyes/Eyes_48x48_07.png"),
}

const outfit_spritesheet = {
	0: preload("res://art/char_creator/outfit/Outfit_01_48x48_01.png"),
	1: preload("res://art/char_creator/outfit/Outfit_01_48x48_02.png"),
	2: preload("res://art/char_creator/outfit/Outfit_01_48x48_03.png"),
	3: preload("res://art/char_creator/outfit/Outfit_01_48x48_04.png"),
}

const facial_hair_spritesheet = {
	0: null,
	1: preload("res://art/char_creator/facial_hair/Accessory_12_Mustache_48x48_01.png"),
	2: preload("res://art/char_creator/facial_hair/Accessory_12_Mustache_48x48_02.png"),
	3: preload("res://art/char_creator/facial_hair/Accessory_12_Mustache_48x48_03.png"),
	4: preload("res://art/char_creator/facial_hair/Accessory_13_Beard_48x48_01.png"),
	5: preload("res://art/char_creator/facial_hair/Accessory_13_Beard_48x48_02.png"),
	6: preload("res://art/char_creator/facial_hair/Accessory_13_Beard_48x48_03.png"),
}

const glasses_spritesheet = {
	0: null,
	1: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_01.png"),
	2: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_02.png"),
	3: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_03.png"),
	4: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_04.png"),
	5: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_05.png"),
	6: preload("res://art/char_creator/glasses/Accessory_15_Glasses_48x48_06.png"),
}

const hats_spritesheet = {
	0: null,
	1: preload("res://art/char_creator/hats/Accessory_04_Snapback_48x48_01.png"),
	2: preload("res://art/char_creator/hats/Accessory_05_Dino_Snapback_48x48_02.png"),
	3: preload("res://art/char_creator/hats/Accessory_06_Policeman_Hat_48x48_01.png"),
	4: preload("res://art/char_creator/hats/Accessory_07_Bataclava_48x48_01.png"),
	5: preload("res://art/char_creator/hats/Accessory_08_Detective_Hat_48x48_01.png"),
	6: preload("res://art/char_creator/hats/Accessory_11_Beanie_48x48_01.png"),
	7: preload("res://art/char_creator/hats/Accessory_18_Chef_48x48_01.png"),
	8: preload("res://art/char_creator/hats/Accessory_19_Party_Cone_48x48_01.png"),
}
