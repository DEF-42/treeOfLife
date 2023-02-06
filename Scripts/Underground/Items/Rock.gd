class_name Rock
extends CellThing

func _ready():
	self.VARIATIONS = {
		1: Rect2(Vector2(16, 11), self.grid.cell_size),
		2: Rect2(Vector2(124, 10), self.grid.cell_size),
	}
	self.skin = load("res://Assets/Underground/Items/rock_sprite.png")
