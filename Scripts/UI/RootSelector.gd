extends Node2D

const MAX_REFRESH = 3

var is_day = true
var root_dictionary = {
	# T roots
	1: {
		1: Rect2(22, 16, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(121, 16, GAME.cell_size.x, GAME.cell_size.y),
		3: Rect2(222, 19, GAME.cell_size.x, GAME.cell_size.y),
	},
	# L roots
	2: {
		1: Rect2(794, 18, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(802, 98, GAME.cell_size.x, GAME.cell_size.y),
		3: Rect2(713, 259, GAME.cell_size.x, GAME.cell_size.y),
	},
	# I roots
	3: {
		1: Rect2(510, 33, GAME.cell_size.x, GAME.cell_size.y),
		2: Rect2(591, 33, GAME.cell_size.x, GAME.cell_size.y),
		3: Rect2(510, 120, GAME.cell_size.x, GAME.cell_size.y),
	}
}
var rng = RandomNumberGenerator.new()
var available_refresh_counter: int = 0 setget set_available_refresh_counter, get_available_refresh_counter


func _ready():
	rng.randomize()
	_randomize_all_roots()
	set_available_refresh_counter(MAX_REFRESH)
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")

func _process(delta):
	if Input.is_action_just_pressed("first_root"):
		_create_root($RootsGroup/Root)
	if is_day && Input.is_action_just_pressed("second_root"):
		_create_root($RootsGroup/Root2)
	if is_day && Input.is_action_just_pressed("third_root"):
		_create_root($RootsGroup/Root3)
	if Input.is_action_just_pressed("refresh_roots"):
		if get_available_refresh_counter() == 0:
			return
		_randomize_all_roots()
		_decrement_available_refresh_counter()


### SIGNALS ###
func _on_day_state_changed(_is_day: bool):
	is_day = _is_day
	if _is_day:
		set_available_refresh_counter(MAX_REFRESH)
		$RootsGroup/Root2.set_modulate("ffffff")
		$RootsGroup/Root3.set_modulate("ffffff")
	else:
		$RootsGroup/Root2.set_modulate("4ae8d6d6")
		$RootsGroup/Root3.set_modulate("4ae8d6d6")


### FUNCTIONS ###
func _create_root(root: Node2D):
	EVENTS.emit_signal("create_root", root)
	if GAME.get_can_create_root():
		_randomize_root(root)

func _randomize_root(root: Node2D):
	if root.get_child(0) != null:
		var root_sprite = root.get_child(0)	
		root.get_child(0).region_rect = _get_random_root_texture()
		root.rotate(_get_random_root_rotation())
		_define_available_link(root)

func _randomize_all_roots():
	for root in $RootsGroup.get_children():
		_randomize_root(root)
	
func _get_random_root_texture() -> Rect2:
	var random_root_type = rng.randi_range(1, root_dictionary.size())
	var root_type_variations_dictionary = root_dictionary.get(random_root_type)
	var random_variation = rng.randi_range(1, root_type_variations_dictionary.size())
	return root_type_variations_dictionary.get(random_variation)
	
func _get_random_root_rotation() -> float:
	var random_number = rng.randi_range(0, 3)
	return deg2rad(90 * random_number)

func _decrement_available_refresh_counter():
	set_available_refresh_counter(get_available_refresh_counter() - 1)

func _define_available_link(root: Node2D):
	var root_sprite_rect = root.get_child(0).region_rect
	var root_type: String
	
	for root_type_index in root_dictionary:
		var root_type_variations = root_dictionary.get(root_type_index)
		for variation_index in root_type_variations:
			var variation_rect = root_type_variations.get(variation_index)
			if (variation_rect.has_point(root_sprite_rect.position)):
				if (root_type_index == 1):
					root_type = "T"
				elif (root_type_index == 2):
					root_type = "L"
				elif (root_type_index == 3):
					root_type = "I"
				break
	
	var root_rotation = int(root.rotation_degrees)
	while root_rotation >= 360:
		root_rotation = root_rotation - 360
	if (root_type == "T"):
		if (root_rotation == 0):
			root.can_link_left = true
			root.can_link_top = false
			root.can_link_right = true
			root.can_link_bottom = true
		elif (root_rotation == 90):
			root.can_link_left = true
			root.can_link_top = true
			root.can_link_right = false
			root.can_link_bottom = true
		elif (root_rotation == 180):
			root.can_link_left = true
			root.can_link_top = true
			root.can_link_right = true
			root.can_link_bottom = false
		elif (root_rotation == 270):
			root.can_link_left = false
			root.can_link_top = true
			root.can_link_right = true
			root.can_link_bottom = true
	elif (root_type == "L"):
		if (root_rotation == 0):
			root.can_link_left = true
			root.can_link_top = false
			root.can_link_right = false
			root.can_link_bottom = true
		elif (root_rotation == 90):
			root.can_link_left = true
			root.can_link_top = true
			root.can_link_right = false
			root.can_link_bottom = false
		elif (root_rotation == 180):
			root.can_link_left = false
			root.can_link_top = true
			root.can_link_right = true
			root.can_link_bottom = false
		elif (root_rotation == 270):
			root.can_link_left = false
			root.can_link_top = false
			root.can_link_right = true
			root.can_link_bottom = true
	elif (root_type == "I"):
		if (root_rotation == 0 || root_rotation == 180):
			root.can_link_left = false
			root.can_link_top = true
			root.can_link_right = false
			root.can_link_bottom = true
		elif (root_rotation == 90 || root_rotation == 20):
			root.can_link_left = true
			root.can_link_top = false
			root.can_link_right = true
			root.can_link_bottom = false

### GETTERS / SETTERS ###
func set_available_refresh_counter(val: int):
	if val != available_refresh_counter:
		available_refresh_counter = val
		$AvailableRefreshCounter.text = str(val)
func get_available_refresh_counter() -> int:
	return available_refresh_counter
