class_name Root
extends CellThing

export var can_link = {
	"left": false,
	"right": false,
	"top": false,
	"bottom": false
}

var rng = RandomNumberGenerator.new()
var t_root_variations = {
	1: Rect2(Vector2(22, 10), grid.cell_size),
	2: Rect2(Vector2(121, 10), grid.cell_size),
	3: Rect2(Vector2(222, 10), grid.cell_size),
}
var i_root_variations = {
	1: Rect2(Vector2(500, 33), grid.cell_size),
	2: Rect2(Vector2(581, 33), grid.cell_size),
	3: Rect2(Vector2(500, 120), grid.cell_size),
}
var l_root_variations = {
	1: Rect2(Vector2(794, 13), grid.cell_size),
	2: Rect2(Vector2(802, 108), grid.cell_size),
	3: Rect2(Vector2(713, 251), grid.cell_size),
}

func _ready():
	rng.randomize()
	_randomize_form()
	_randomize_rotation()
	self.skin = load("res://Assets/Underground/Items/root_sprite.png")
	_define_linkable_parts()


### FUNCTIONS ###
func _randomize_form():
	var random_number = rng.randi_range(1, 3)
	if (random_number == 1):
		self.VARIATIONS = t_root_variations
	elif (random_number == 2):
		self.VARIATIONS = i_root_variations
	else:
		self.VARIATIONS = l_root_variations

func _randomize_rotation():
	var random_quarter = rng.randi_range(0, 3)
	var random_rotation = deg2rad(random_quarter * 90)
	self.rotate(random_rotation)

func _define_linkable_parts():
	if (VARIATIONS == t_root_variations):
		if (rotation_degrees == 0):
			can_link.left = true
			can_link.top = false
			can_link.right = true
			can_link.bottom = true
		elif (rotation_degrees == 90):
			can_link.left = true
			can_link.top = true
			can_link.right = false
			can_link.bottom = true
		elif (rotation_degrees == 180):
			can_link.left = true
			can_link.top = true
			can_link.right = true
			can_link.bottom = false
		else:
			can_link.left = false
			can_link.top = true
			can_link.right = true
			can_link.bottom = true
	elif (VARIATIONS == i_root_variations):
		if (rotation_degrees == 0 || rotation_degrees == 180):
			can_link.left = false
			can_link.top = true
			can_link.right = false
			can_link.bottom = true
		else:
			can_link.left = true
			can_link.top = false
			can_link.right = true
			can_link.bottom = false
	else:
		if (rotation_degrees == 0):
			can_link.left = true
			can_link.top = false
			can_link.right = false
			can_link.bottom = true
		elif (rotation_degrees == 90):
			can_link.left = true
			can_link.top = true
			can_link.right = false
			can_link.bottom = false
		elif (rotation_degrees == 180):
			can_link.left = false
			can_link.top = true
			can_link.right = true
			can_link.bottom = false
		else:
			can_link.left = false
			can_link.top = false
			can_link.right = true
			can_link.bottom = true
