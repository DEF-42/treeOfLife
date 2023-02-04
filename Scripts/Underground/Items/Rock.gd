extends Node2D

export var passable = false
export var type = "rock"

var rng = RandomNumberGenerator.new()

const VARIATIONS = {
	1: Rect2(44, 156, 80, 80),
	2: Rect2(152, 155, 80, 80)
}

func _ready():
	rng.randomize()
	var random_number = rng.randi_range(1, 2)
	$Sprite.region_rect = VARIATIONS.get(random_number)
