class_name Sediment
extends CellThing

func _ready():
	self.VARIATIONS = {
		1: Rect2(Vector2(4, 6), self.grid.cell_size),
		2: Rect2(Vector2(97, 5), self.grid.cell_size),
	}
	self.skin = load("res://Assets/Underground/Items/sediment_sprite.png")
