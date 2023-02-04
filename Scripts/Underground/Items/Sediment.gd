extends Node2D

export var passable = true
export var type = "sediment"

var rng = RandomNumberGenerator.new()

const VARIATIONS = {
	1: Rect2(270, 33, 80, 80),
	2: Rect2(271, 120, 80, 80)
}

func _ready():
	rng.randomize()
	var random_number = rng.randi_range(1, 2)
	$Sprite.region_rect = VARIATIONS.get(random_number)
