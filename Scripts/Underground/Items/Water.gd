extends Node2D

export var passable = true
export var type = "water"

var rng = RandomNumberGenerator.new()

const VARIATIONS = {
	1: Rect2(43, 44, 80, 80),
	2: Rect2(168, 34, 80, 80)
}

func _ready():
	rng.randomize()
	var random_number = rng.randi_range(1, 2)
	$Sprite.region_rect = VARIATIONS.get(random_number)
