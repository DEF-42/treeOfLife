extends Node2D

export var type = ""
export var passable = false

var rng = RandomNumberGenerator.new()

var RESOURCES_SPRITES = {
	water = {
		1: Rect2(43, 44, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(168, 34, GAME.cell_size.x, GAME.cell_size.y)
	},
	sediment = {
		1: Rect2(270, 33, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(271, 120, GAME.cell_size.x, GAME.cell_size.y)
	},
	rock = {
		1: Rect2(44, 156, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(152, 155, GAME.cell_size.x, GAME.cell_size.y)
	},
	mushroom = {
		1: Rect2(371, 44, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(373, 136, GAME.cell_size.x, GAME.cell_size.y)
	},
	maya_plate = Rect2(270, 215, GAME.cell_size.x, GAME.cell_size.y)
}


func _ready():
	rng.randomize()
	var type_sprite = RESOURCES_SPRITES.get(type)
	var region_rect
	if (type_sprite is Rect2):
		region_rect = type_sprite
	else:
		var random_number = rng.randi_range(1, 2)
		region_rect = type_sprite.get(random_number)
	
	passable = type != GAME.ROCK
	$Sprite.region_rect = region_rect
