extends Node


var can_create_root: bool = true setget set_can_create_root, get_can_create_root
# True = Jour, False = Nuit
var day_cycle_state: bool = true setget set_day_cycle_state, get_day_cycle_state
var tree_hp: int = 3 setget set_tree_hp, get_tree_hp

var cell_size: Vector2 = Vector2(80, 80)
var grid: PoolVector2Array = []


### ACCESSORS ###
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


### FUNCTIONS ###
func check_free_in_grid(root_position) -> bool:
	if grid.has(_attribute_coordinates(root_position)):
		return false
	else: 
		_add_to_grid(root_position)
		return true

func get_grid() -> PoolVector2Array:
	return grid


func _add_to_grid(root_position: Vector2):
	grid.append(_attribute_coordinates(root_position))
	
func _attribute_coordinates(root_position: Vector2) -> Vector2:
	return Vector2(root_position.x / cell_size.x, root_position.y / cell_size.y)


func invert_day_state():
	set_day_cycle_state(!get_day_cycle_state())
