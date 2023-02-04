extends Node


var cell_size: Vector2 = Vector2(80, 80)
var grid: PoolVector2Array = []


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
