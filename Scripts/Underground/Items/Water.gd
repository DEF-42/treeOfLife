class_name Water
extends CellThing

func _ready():
	self.VARIATIONS = {
		1: Rect2(Vector2(15, 21), self.grid.cell_size),
		2: Rect2(Vector2(140, 12), self.grid.cell_size),
	}
	self.skin = load("res://Assets/Underground/Items/water_sprite.png")
