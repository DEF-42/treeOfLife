tool
extends Node2D

export var grid: Resource = preload("res://Resources/Grid.tres")

const root_placed_on_rock := preload("res://Sounds/UI/SFX_Placer_Interdit_Rock.wav")
const root_placed_on_root := preload("res://Sounds/UI/SFX_Placer_Interdit_Racine.wav")
const root_placed_on_dirt_forbidden := preload("res://Sounds/UI/SFX_Deplacement_Interdit_Dirt.wav")
const root_placed_on_dirt := preload("res://Sounds/UI/SFX_Placer_Racine_2.wav")
const root_placed_on_sediment := preload("res://Sounds/UI/sediments.wav")
const root_placed_on_mushroom := preload("res://Sounds/UI/Champi.wav")
const root_placed_on_maya_plate := preload("res://Sounds/UI/Maya.wav")
const cell_thing_types = [MayaPlate]
#const cell_thing_types = [Rock, MayaPlate, Sediment, Water, Mushroom]
const cell_things_spawn_number_in_base_sprite = 10
const cell_things_spawn_number_by_new_sprites = 10

var root_placed_on_water_variations = {
	1: preload("res://Sounds/UI/SFX_Water_1.wav"),
	2: preload("res://Sounds/UI/SFX_Water_2.wav"),
	3: preload("res://Sounds/UI/SFX_Water_3.wav"),
}
var maya_plate_placed = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	EVENTS.connect("create_root", self, "_on_create_root")
	_place_first_root()
	_place_cell_things()
#
#	# Roots with coherent links
#	var min_x = 0
#	var max_x = 10
#	var max_y = 10
#	x = min_x
#	y = 0
#	while y <= max_y:
#		while (x <= max_x):
#			var root_instance = Root.new()
#			root_instance.position = grid.calculate_map_position(Vector2(x, y))
#			self.add_child(root_instance)
#
#			if (_can_place_root(root_instance) || (x == 4)):
#				grid.add(root_instance)
#			else:
#				root_instance.queue_free()
#				self.remove_child(root_instance)
#			x += 1
#		x = min_x
#		y += 1

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

func _place_cell_things(initial_sprite = false):
	var min_x = 0
	var max_x = 19 - 3
	var min_y
	var max_y
	if (initial_sprite):
		min_y = 3
		max_y = 15 - 3
	else:
		min_y = 16 - 3
		max_y = 16 - 3
	
	for cell_thing_index in range(cell_things_spawn_number_in_base_sprite):
		var x = rng.randi_range(0, 19)
		var y = rng.randi_range(3, 15)
		
		var cell_thing_class = _randomize_cell_thing()
#		if (y <= 8):
#			while cell_thing_class == MayaPlate:
#				cell_thing_class = _randomize_cell_thing()
		
		_spawn_cell_things_square(cell_thing_class, Vector2(x, y))

func _on_create_root(root: Node2D):
	var duplicatedRoot = root.duplicate()
	if GAME.can_place_root($GridKinematic.position, duplicatedRoot):
		$RootPlacedSound.stop()
				
		if (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.SEDIMENT)):
			GAME.increment_sediment()
			if ($RootPlacedSound.stream != root_placed_on_sediment):
				$RootPlacedSound.stream = root_placed_on_sediment
		elif (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.MUSHROOM)):
			if (GAME.get_tree_mushrooms() == 0):
				EVENTS.emit_signal("mushroom_armor_gained")
			GAME.increment_mushrooms()
			if ($RootPlacedSound.stream != root_placed_on_mushroom):
				$RootPlacedSound.stream = root_placed_on_mushroom
		elif (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.WATER)):
			GAME.increment_water()
			EVENTS.emit_signal("water_linked")
			var random_index = rng.randi_range(1, root_placed_on_water_variations.size())
			var stream = root_placed_on_water_variations.get(random_index)
			if ($RootPlacedSound.stream != stream):
				$RootPlacedSound.stream = stream
		elif (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.MAYA_PLATE)):
			EVENTS.emit_signal("maya_plate_found")
			if ($RootPlacedSound.stream != root_placed_on_maya_plate):
				$RootPlacedSound.stream = root_placed_on_maya_plate
		elif ($RootPlacedSound.stream != root_placed_on_dirt):
				$RootPlacedSound.stream = root_placed_on_dirt
		
		duplicatedRoot.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", duplicatedRoot)
		GAME._add_to_grid($GridKinematic.position, duplicatedRoot)
		$RootPlacedSound.play()
	else:
		duplicatedRoot.queue_free()
		$RootPlacedForbiddenSound.stop()
		if GAME.check_cell_contains_node_type($GridKinematic.position, GAME.ROCK):
			if ($RootPlacedForbiddenSound.stream != root_placed_on_rock):
				$RootPlacedForbiddenSound.stream = root_placed_on_rock
		elif GAME.check_cell_contains_node_type($GridKinematic.position, GAME.ROOT):
			if ($RootPlacedForbiddenSound.stream != root_placed_on_root):
				$RootPlacedForbiddenSound.stream = root_placed_on_root
		else:
			$RootPlacedForbiddenSound.stream = root_placed_on_dirt_forbidden
		$RootPlacedForbiddenSound.play()

func _place_first_root():
	var first_root = Root.new()
	var random_cell_under_tree = rng.randi_range(7, 12)
	first_root.position = grid.calculate_map_position(Vector2(random_cell_under_tree, 0))
	add_child_below_node($".", first_root)
	grid.add(first_root)

func _randomize_cell_thing():
	var random_index = rng.randi_range(0, cell_thing_types.size() - 1)
	var selected_cell_thing = cell_thing_types[random_index]
	
	if (selected_cell_thing == MayaPlate):
		cell_thing_types.remove(random_index)
	
#	if (!maya_plate_placed && selected_cell_thing == MayaPlate):
#		maya_plate_placed = true
	
	return selected_cell_thing

func _spawn_cell_things_square(cell_thing_class, starting_cell_position: Vector2):
	var minimum = 1
	var maximum = 9
	if(cell_thing_class == MayaPlate):
		maximum = 1
	var resource_number = rng.randi_range(minimum, maximum)
	
	var current_row = 0
	for i in range(0, resource_number):
		var x = (i % 3) + starting_cell_position.x
		var y = current_row + starting_cell_position.y
		
		var skip = false
		if (i > minimum):
			skip = rng.randi_range(0, 1)
			if (skip == 1):
				continue

		var cell_thing = cell_thing_class.new()
		var cell_position = Vector2(x, y)
		cell_thing.position = grid.calculate_map_position(cell_position);
		self.add_child(cell_thing)
		if(grid.cell_is_empty(cell_position)):
			grid.add(cell_thing)
		else:
			self.remove_child(cell_thing)

#		var resource_instance = cell_thing.new()
#		var global_position = Vector2(resource_instance.global_position.x, resource_instance.global_position.y - 500)
#		if (!GAME.check_free_in_grid(global_position, false)):
#			resource_instance.queue_free()
#			continue
#
#		GAME._add_to_grid(global_position, resource_instance)
#		if (i % 3 == 2):
#			current_row = current_row + 1
#	var spawn_point_instance = cell_things_spawn_point_scene.instance()
#	spawn_point_instance.resource_type = resource_type
#	spawn_point_instance.translate(Vector2(x, y))
#	$".".add_child(spawn_point_instance)
