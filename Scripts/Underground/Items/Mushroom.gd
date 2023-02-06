class_name Mushroom
extends CellThing

func _ready():
	self.VARIATIONS = {
		1: Rect2(Vector2(13, 3), self.grid.cell_size),
		2: Rect2(Vector2(110, 4), self.grid.cell_size),
	}
	self.skin = load("res://Assets/Underground/Items/mushroom_sprite.png")
