class_name Root
extends CellThing

const sprite = preload("res://Assets/Underground/Items/root_sprite.png")

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
	randomize_instance()
	_randomize_form()
	_randomize_rotation()
	self.skin = sprite
	self.variation = rng.randi_range(1, 3)


### FUNCTIONS ###
func randomize_instance():
	_randomize_form()
	_randomize_rotation()
	self.skin = sprite
	self.variation = rng.randi_range(1, 3)

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

func define_linkable_parts():
	var can_link = {}
	if (self.VARIATIONS == t_root_variations):
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
		elif rotation_degrees == 270:
			can_link.left = false
			can_link.top = true
			can_link.right = true
			can_link.bottom = true
	elif (self.VARIATIONS == i_root_variations):
		if (rotation_degrees == 0 || rotation_degrees == 180):
			can_link.left = false
			can_link.top = true
			can_link.right = false
			can_link.bottom = true
		elif (rotation_degrees == 90 || rotation_degrees == 270):
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
		elif rotation_degrees == 270:
			can_link.left = false
			can_link.top = false
			can_link.right = true
			can_link.bottom = true
	return can_link
	
func can_link(root_to_link: Root, direction: String) -> bool:
	var root_to_link_links = root_to_link.define_linkable_parts()
	var current_links = define_linkable_parts()
	
	return (direction == "left" && current_links.left && root_to_link_links.right) || (direction == "top" && current_links.top && root_to_link_links.bottom) || (direction == "right" && current_links.right && root_to_link_links.left) || (direction == "bottom" && current_links.bottom && root_to_link_links.top)

func print_infos(tag: String):	
#	Form
	var form = ""
	if (VARIATIONS == t_root_variations):
		print("Form : T")
	elif (VARIATIONS == i_root_variations):
		print("Form : I")
	elif (VARIATIONS == l_root_variations):
		print("Form : L")
	else:
		print("Form non retrouvée")
	
#	Rotation
	print("Rotation : ", rotation_degrees, "°")
	
#	Links
	var can_link = define_linkable_parts()
	if (can_link.left):
		print("Has a link on left side")
	if (can_link.top):
		print("Has a link on top side")
	if (can_link.right):
		print("Has a link on right side")
	if (can_link.bottom):
		print("Has a link on bottom side")
	print("------")
