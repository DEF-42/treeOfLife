tool
class_name CellThing
extends Sprite

export var grid: Resource = preload("res://Resources/Grid.tres")
# Texture representing the resource.
# With the `tool` mode, assigning a new texture to this property in the inspector will update the
# unit's sprite instantly. See `set_skin()` below.
export var skin: Texture setget set_skin
export var variation: int = 1
export var outside_grid = false


# Coordinates of the grid's cell the unit is on.
var cell := Vector2.ZERO setget set_cell
var VARIATIONS = {}

func _ready():
	set_process(false)
	if (outside_grid):
		return

	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)

# When changing the `cell`'s value, we don't want to allow coordinates outside the grid, so we clamp
# them.
func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)


# Both setters below manipulate the unit's Sprite node.
# Here, we update the sprite's texture.
func set_skin(value: Texture) -> void:
	skin = value
	# Setter functions are called during the node's `_init()` callback, before they entered the
	# tree. At that point in time, the `_sprite` variable is `null`. If so, we have to wait to
	# update the sprite's properties.
	self.texture = value
	
	if (!VARIATIONS.empty()):
		self.region_enabled = true
		self.region_rect = VARIATIONS.get(variation)
