extends Node

const ROOT = "root"
const ROCK = "rock"
const WATER = "water"
const SEDIMENT = "sediment"
const MUSHROOM = "mushroom"
const MAYA_PLATE = "maya_plate"

var resource_types = [ROCK, WATER, SEDIMENT, MUSHROOM, MAYA_PLATE]

var available_ants: int = 3 setget set_available_ants, get_available_ants
var can_create_root: bool = true setget set_can_create_root, get_can_create_root
# True = Jour, False = Nuit
var day_cycle_state: bool = true setget set_day_cycle_state, get_day_cycle_state
var tree_hp: int = 3 setget set_tree_hp, get_tree_hp
var tree_xp: int = 0 setget set_tree_xp, get_tree_xp
var sediments: int = 0
var water: int = 0
var mushrooms: int = 0

var cell_size: Vector2 = Vector2(80, 80)
var grid = []
var passed_nights = 0
var root_sprites_dictionary = {
	# T roots
	1: {
		1: Rect2(22, 10, cell_size.x, cell_size.y),
		2: Rect2(121, 10, cell_size.x, cell_size.y),
		3: Rect2(222, 10, cell_size.x, cell_size.y),
	},
	# L roots
	2: {
		1: Rect2(794, 13, cell_size.x, cell_size.y),
		2: Rect2(802, 108, cell_size.x, cell_size.y),
		3: Rect2(713, 251, cell_size.x, cell_size.y),
	},
	# I roots
	3: {
		1: Rect2(500, 33, cell_size.x, cell_size.y),
		2: Rect2(581, 33, cell_size.x, cell_size.y),
		3: Rect2(500, 120, cell_size.x, cell_size.y),
	}
}


### ACCESSORS ###
func set_available_ants(val: int):
	if val != available_ants:
		available_ants = val
func get_available_ants() -> int:
	return available_ants

func set_can_create_root(val: bool):
	if val != can_create_root:
		can_create_root = val
func get_can_create_root() -> bool:
	return can_create_root

func get_day_cycle_state() -> bool:
	return day_cycle_state
func set_day_cycle_state(val: bool):
	if val != day_cycle_state:
		day_cycle_state = val
		EVENTS.emit_signal("day_state_changed", val)

func set_tree_hp(val: int):
	if val != tree_hp:
		tree_hp = val
func get_tree_hp() -> int:
	return tree_hp
	
func set_tree_xp(val: int):
	if val != tree_xp:
		tree_xp = val
func get_tree_xp() -> int:
	return tree_xp


### FUNCTIONS ###
func can_place_root(position_to_place: Vector2, root: Node2D) -> bool:
	if !check_free_in_grid(position_to_place):
		return false
	
	# On essaye de choper une racine sur les bords de la cellule
	
	# A Gauche
	var left_cell_position = Vector2(position_to_place.x - cell_size.x, position_to_place.y)
	var left_cell = get_in_grid(left_cell_position)
	if (root.can_link_left && left_cell != null && left_cell.node.type == ROOT && left_cell.node.can_link_right):
		return true

	# Au Dessus		
	var top_cell_position = Vector2(position_to_place.x, position_to_place.y - cell_size.y)
	var top_cell = get_in_grid(top_cell_position)
	if (root.can_link_top && top_cell != null && top_cell.node.type == ROOT && top_cell.node.can_link_bottom):
		return true
		
	# A Droite
	var right_cell_position = Vector2(position_to_place.x + cell_size.x, position_to_place.y)
	var right_cell = get_in_grid(right_cell_position)
	if (root.can_link_right && right_cell != null && right_cell.node.type == ROOT && right_cell.node.can_link_left):
		return true
		
	# En Dessous
	var bottom_cell_position = Vector2(position_to_place.x, position_to_place.y + cell_size.y)
	var bottom_cell = get_in_grid(bottom_cell_position)
	if (root.can_link_bottom && bottom_cell != null && bottom_cell.node.type == ROOT && bottom_cell.node.can_link_top):
		return true
	
	return false

func check_free_in_grid(position: Vector2, check_passable = true) -> bool:
	var attribute_coordinates = _attribute_coordinates(position)
	var free = true;
	for x in grid:
		if x.position == attribute_coordinates:
			if check_passable:
				free = x.node.passable
			else:
				free = false
			break
	
	return free;
	
func check_cell_contains_node_type(position, node_type: String) -> bool:
	var attribute_coordinates = _attribute_coordinates(position)
	var contains_node_type = false;
	for x in grid:
		if (x.position == attribute_coordinates && x.node.type == node_type):
			contains_node_type = true;
			break;
	return contains_node_type;

func get_grid():
	return grid

func get_in_grid(position: Vector2):
	for cell in grid:
		if cell.position == _attribute_coordinates(position):
			return cell
	return null


func _add_to_grid(position: Vector2, node: Node2D):
	var coordinated = _attribute_coordinates(position)
	# Replace in grid if position exists
	var cell = get_in_grid(position)
	if (cell != null):
		cell.node = node
	else:
		grid.append({"position": coordinated, "node": node})
	
func _attribute_coordinates(root_position: Vector2) -> Vector2:
	return Vector2(root_position.x / cell_size.x, root_position.y / cell_size.y)

func invert_day_state():
	set_day_cycle_state(!get_day_cycle_state())

func increment_sediment():
	sediments = sediments + 1

func increment_water():
	water = water + 1

func increment_mushrooms():
	mushrooms = mushrooms + 1

func increment_passed_nights():
	passed_nights = passed_nights + 1
	
func _get_random_root_texture(rng: RandomNumberGenerator) -> Rect2:
	var random_root_type = rng.randi_range(1, root_sprites_dictionary.size())
	var root_type_variations_dictionary = root_sprites_dictionary.get(random_root_type)
	var random_variation = rng.randi_range(1, root_type_variations_dictionary.size())
	return root_type_variations_dictionary.get(random_variation)

func _get_root_sprite_type(root_sprite_rect_position):
	var root_type: String
	for root_type_index in root_sprites_dictionary:
		var root_type_variations = root_sprites_dictionary.get(root_type_index)
		for variation_index in root_type_variations:
			var variation_rect = root_type_variations.get(variation_index)
			if (variation_rect.has_point(root_sprite_rect_position)):
				if (root_type_index == 1):
					root_type = "T"
				elif (root_type_index == 2):
					root_type = "L"
				elif (root_type_index == 3):
					root_type = "I"
				return root_type
	return null

func _define_root_available_link(root: Node2D):
	var root_sprite_rect = root.get_child(0).region_rect
	var root_type = _get_root_sprite_type(root_sprite_rect.position)
	
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
		elif (root_rotation == 90 || root_rotation == 270):
			root.can_link_left = true
			root.can_link_top = false
			root.can_link_right = true
			root.can_link_bottom = false
