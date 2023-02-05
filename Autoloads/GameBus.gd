extends Node

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

var cell_size: Vector2 = Vector2(80, 80)
var grid = []


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
func check_free_in_grid(root_position, check_passable = true) -> bool:
	var attribute_coordinates = _attribute_coordinates(root_position)
	var free = true;
	for x in grid:
		if x.position == attribute_coordinates:
			if check_passable:
				free = x.node.passable
			else:
				free = false
			break
	
	return free;
	
func check_cell_contains_node_type(root_position, node_type: String) -> bool:
	var attribute_coordinates = _attribute_coordinates(root_position)
	var contains_node_type = false;
	for x in grid:
		if (x.position == attribute_coordinates && x.node.type == node_type):
			contains_node_type = true;
			break;
	return contains_node_type;

func get_grid():
	return grid


func _add_to_grid(root_position: Vector2, node: Node2D):
	grid.append({"position": _attribute_coordinates(root_position), "node": node})
	
func _attribute_coordinates(root_position: Vector2) -> Vector2:
	return Vector2(root_position.x / cell_size.x, root_position.y / cell_size.y)

func invert_day_state():
	set_day_cycle_state(!get_day_cycle_state())

func increment_sediment():
	sediments = sediments + 1
