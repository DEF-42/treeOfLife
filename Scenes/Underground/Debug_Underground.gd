 extends Node2D

export var grid: Resource = preload("res://Resources/Grid.tres")

var rng = RandomNumberGenerator.new()

func _ready():
	var resources = [Sediment, Mushroom, Water]
	var y = 0
	var x = 0
	
	# ROCKS
	for i in range(2):
		x = i
		var rock_instance = Rock.new()
		rock_instance.variation = x + 1

		rock_instance.position = grid.calculate_map_position(Vector2(x, y))
		_add_to_game(rock_instance)

	y += 1

	# Resources
	for resource in resources:
		for i in range(2):
			x = i
			var resource_instance = resource.new()
			resource_instance.variation = x + 1

			resource_instance.position = grid.calculate_map_position(Vector2(x, y))
			_add_to_game(resource_instance)
		x = 0
		y += 1

	var maya_plate_instance = MayaPlate.new()
	maya_plate_instance.position = grid.calculate_map_position(Vector2(x, y))
	_add_to_game(maya_plate_instance)
	
	# Roots
	y = 0
	x = 16
	for root_form in range(3):
		for form_variation in range(3):
			for rotation in range(4):
				var root_instance = Root.new()
				root_instance.variation = form_variation + 1
				root_instance.position = grid.calculate_map_position(Vector2(x, y))
				_add_to_game(root_instance)
				x += 1
			x = 16
			y += 1
		
	# Roots with coherent links
	var min_x = 0
	var max_x = 10
	var max_y = 10
	x = min_x
	y = 0
	while y <= max_y:
		while (x <= max_x):
			var root_instance = Root.new()
			root_instance.position = grid.calculate_map_position(Vector2(x, y))
			self.add_child(root_instance)

			if (_can_place_root(root_instance) || (x == 4)):
				grid.add(root_instance)
			else:
				root_instance.queue_free()
				self.remove_child(root_instance)
			x += 1
		x = min_x
		y += 1

func _can_place_root(root: Root) -> bool:
	var current_cell_coordinates = grid.calculate_grid_coordinates(root.position)
	var current_cell = grid.get_at_coordinates(current_cell_coordinates)
	
	# Impassable cell thing on current cell
	if (current_cell != null && (current_cell is Rock || current_cell is Root)):
		return false
	
	## Left cell ##
	var left_cell_coordinates = Vector2(current_cell_coordinates.x - 1, current_cell_coordinates.y)
	var left_cell = grid.get_at_coordinates(left_cell_coordinates)
	if (left_cell != null && left_cell is Root && root.can_link(left_cell, "left")):
		return true
	
	## Top cell ##
	var top_cell_coordinates = Vector2(current_cell_coordinates.x, current_cell_coordinates.y - 1)
	var top_cell = grid.get_at_coordinates(top_cell_coordinates)
	if (top_cell != null && top_cell is Root && root.can_link(top_cell, "top")):
		return true
		
	## Right cell ##
	var right_cell_coordinates = Vector2(current_cell_coordinates.x + 1, current_cell_coordinates.y)
	var right_cell = grid.get_at_coordinates(right_cell_coordinates)
	if (right_cell != null && right_cell is Root && root.can_link(right_cell, "right")):
		return true
	
	## Bottom cell ##
	var bottom_cell_coordinates = Vector2(current_cell_coordinates.x, current_cell_coordinates.y + 1)
	var bottom_cell = grid.get_at_coordinates(bottom_cell_coordinates)
	if (bottom_cell != null && bottom_cell is Root && root.can_link(bottom_cell, "bottom")):
		return true
		
	return false

func _add_to_game(cell_thing: CellThing) -> void:
	self.add_child(cell_thing)
	grid.add(cell_thing)
	
