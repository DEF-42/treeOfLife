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
var form: String

func _ready():
	rng.randomize()


### FUNCTIONS ###
func randomize_instance():
	_randomize_form()
	_randomize_rotation()
	self.variation = rng.randi_range(1, 3)
	self.skin = sprite

func _randomize_form():
	var random_number = rng.randi_range(1, 3)
	if (random_number == 1):
		self.VARIATIONS = t_root_variations
		self.form = "T"
	elif (random_number == 2):
		self.VARIATIONS = i_root_variations
		self.form = "I"
	else:
		self.VARIATIONS = l_root_variations
		self.form = "L"

func _randomize_rotation():
	var random_quarter = rng.randi_range(0, 3)
	var random_rotation = deg2rad(random_quarter * 90)
	# Reset rotation
	self.rotate(-self.rotation)
	# Apply new rotation
	self.rotate(random_rotation)

func assign(root: Root):
	self.VARIATIONS = root.VARIATIONS
	self.form = root.form
	# Reset rotation
	self.rotate(-self.rotation)
	# Apply new rotation
	self.rotate(root.rotation)
	self.variation = root.variation
	self.skin = root.sprite

func define_linkable_parts():
	var can_link = {}
	var modulated_rotation_degrees = int(rotation_degrees) % 360
	if (self.form == "T"):
		if (modulated_rotation_degrees == 0):
			can_link.left = true
			can_link.top = false
			can_link.right = true
			can_link.bottom = true
		elif (modulated_rotation_degrees == 90):
			can_link.left = true
			can_link.top = true
			can_link.right = false
			can_link.bottom = true
		elif (modulated_rotation_degrees == 180):
			can_link.left = true
			can_link.top = true
			can_link.right = true
			can_link.bottom = false
		elif modulated_rotation_degrees == 270:
			can_link.left = false
			can_link.top = true
			can_link.right = true
			can_link.bottom = true
	elif (self.form == "I"):
		if (modulated_rotation_degrees == 0 || modulated_rotation_degrees == 180):
			can_link.left = false
			can_link.top = true
			can_link.right = false
			can_link.bottom = true
		elif (modulated_rotation_degrees == 90 || modulated_rotation_degrees == 270):
			can_link.left = true
			can_link.top = false
			can_link.right = true
			can_link.bottom = false
	elif (self.form == "L"):
		if (modulated_rotation_degrees == 0):
			can_link.left = true
			can_link.top = false
			can_link.right = false
			can_link.bottom = true
		elif (modulated_rotation_degrees == 90):
			can_link.left = true
			can_link.top = true
			can_link.right = false
			can_link.bottom = false
		elif (modulated_rotation_degrees == 180):
			can_link.left = false
			can_link.top = true
			can_link.right = true
			can_link.bottom = false
		elif modulated_rotation_degrees == 270:
			can_link.left = false
			can_link.top = false
			can_link.right = true
			can_link.bottom = true
	else:
		return null
	return can_link

func print_infos(tag: String):	
	print("## ", tag, " ##")
	print("Coordonnées ", self.cell)
	print("Form : ", self.form)
	print("Rotation : ", rotation_degrees, "°")
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
