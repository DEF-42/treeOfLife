extends Node2D

export var type = "rock"
export var passable = false

var rng = RandomNumberGenerator.new()

const RESOURCES_SPRITES = {
	water = {
		1: Rect2(43, 44, 80, 80),
		2: Rect2(168, 34, 80, 80)
	},
	sediment = {
		1: Rect2(270, 33, 80, 80),
		2: Rect2(271, 120, 80, 80)
	},
	rock = {
		1: Rect2(44, 156, 80, 80),
		2: Rect2(152, 155, 80, 80)
	},
	mushroom = {
		1: Rect2(371, 44, 80, 80),
		2: Rect2(373, 136, 80, 80)
	},
	maya_plate = Rect2(270, 215, 80, 80)
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
	
	$Sprite.region_rect = region_rect
