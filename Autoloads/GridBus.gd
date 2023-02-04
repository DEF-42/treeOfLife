extends Node


var can_create_root: bool = true setget set_can_create_root, get_can_create_root
var cell_size: Vector2 = Vector2(80, 80)
var grid: PoolVector2Array = []


func set_can_create_root(val: bool):
	if val != can_create_root:
		can_create_root = val

func get_can_create_root() -> bool:
	return can_create_root


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
