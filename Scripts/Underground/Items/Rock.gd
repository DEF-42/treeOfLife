extends Node2D

export var passable = false
export var type = "rock"

var rng = RandomNumberGenerator.new()

const VARIATIONS = {
	1: Rect2(10, 108, 80, 80),
	2: Rect2(114, 107, 80, 80)
}

func _ready():
	rng.randomize()
	var random_number = rng.randi_range(1, 2)
	$Sprite.region_rect = VARIATIONS.get(random_number)
