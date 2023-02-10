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
const cell_thing_types = [Rock, MayaPlate, Sediment, Water, Mushroom]
const cell_things_spawn_number_in_base_sprite = 12
const rows_to_add_on_trigger = 16

var root_placed_on_water_variations = {
	1: preload("res://Sounds/UI/SFX_Water_1.wav"),
	2: preload("res://Sounds/UI/SFX_Water_2.wav"),
	3: preload("res://Sounds/UI/SFX_Water_3.wav"),
}
var maya_plate_placed = false
var rng = RandomNumberGenerator.new()
var y_add_layers_trigger = 8

### BUILT-IN ###
func _ready():
	rng.randomize()
	_place_first_root()
	_place_cell_things()
	EVENTS.connect("select_root", self, "_on_root_selected")
	EVENTS.connect("try_place_root", self, "_on_try_placing_root")
	_limit_camera_bottom()

### SIGNALS ###
func _on_root_selected(root: Root):
	$GridSelector/SelectedRoot.texture = root.texture
	$GridSelector/SelectedRoot.region_rect = root.region_rect
	$GridSelector/SelectedRoot.rotation = root.rotation

func _on_try_placing_root(root: Root):
	var duplicated_root = root.duplicate()
	duplicated_root.assign(root)
	var current_cell = grid.get_at_coordinates($GridSelector.cell)
	
	if (self._can_place_root(duplicated_root)):
		duplicated_root.cell = $GridSelector.cell
		duplicated_root.position = grid.calculate_map_position(duplicated_root.cell)
		$CellThings.add_child(duplicated_root)
		$RootPlacedSound.stop()

		if (current_cell is Sediment):
			GAME.increment_sediment()
			if ($RootPlacedSound.stream != root_placed_on_sediment):
				$RootPlacedSound.stream = root_placed_on_sediment
		elif (current_cell is Mushroom):
			if (GAME.get_tree_mushrooms() == 0):
				EVENTS.emit_signal("mushroom_armor_gained")
			GAME.increment_mushrooms()
			if ($RootPlacedSound.stream != root_placed_on_mushroom):
				$RootPlacedSound.stream = root_placed_on_mushroom
		elif (current_cell is Water):
			GAME.increment_water()
			EVENTS.emit_signal("water_linked")
			var random_index = rng.randi_range(1, root_placed_on_water_variations.size())
			var stream = root_placed_on_water_variations.get(random_index)
			if ($RootPlacedSound.stream != stream):
				$RootPlacedSound.stream = stream
		elif (current_cell is MayaPlate):
			EVENTS.emit_signal("maya_plate_found")
			if ($RootPlacedSound.stream != root_placed_on_maya_plate):
				$RootPlacedSound.stream = root_placed_on_maya_plate
		elif ($RootPlacedSound.stream != root_placed_on_dirt):
				$RootPlacedSound.stream = root_placed_on_dirt
				
		grid.add(duplicated_root)
		$RootPlacedSound.play()
		EVENTS.emit_signal("root_placed")
		
		if (duplicated_root.cell.y == y_add_layers_trigger):
			_add_underground_layer()
		
	else:
		duplicated_root.queue_free()
		$RootPlacedForbiddenSound.stop()
		if current_cell is Rock:
			if ($RootPlacedForbiddenSound.stream != root_placed_on_rock):
				$RootPlacedForbiddenSound.stream = root_placed_on_rock
		elif current_cell is Root:
			if ($RootPlacedForbiddenSound.stream != root_placed_on_root):
				$RootPlacedForbiddenSound.stream = root_placed_on_root
		else:
			$RootPlacedForbiddenSound.stream = root_placed_on_dirt_forbidden
		$RootPlacedForbiddenSound.play()

### FUNCTIONS ###
func _can_place_root(root: Root) -> bool:
	var current_cell_coordinates = $GridSelector.cell
	var current_cell = grid.get_at_coordinates(current_cell_coordinates)
	
	# Impassable cell thing on current cell
	if (current_cell != null && (current_cell is Rock || current_cell is Root)):
		return false
	
	## Left cell ##
	var left_cell_coordinates = current_cell_coordinates + Vector2(-1, 0)
	var left_cell = grid.get_at_coordinates(left_cell_coordinates)
	if (left_cell != null && left_cell is Root && can_link(root, left_cell, "left")):
		return true
	
	## Top cell ##
	var top_cell_coordinates = current_cell_coordinates + Vector2(0, -1)
	var top_cell = grid.get_at_coordinates(top_cell_coordinates)
	if (top_cell != null && top_cell is Root && can_link(root, top_cell, "top")):
		return true
		
	## Right cell ##
	var right_cell_coordinates = current_cell_coordinates + Vector2(1, 0)
	var right_cell = grid.get_at_coordinates(right_cell_coordinates)
	if (right_cell != null && right_cell is Root && can_link(root, right_cell, "right")):
		return true
	
	## Bottom cell ##
	var bottom_cell_coordinates = current_cell_coordinates + Vector2(0, 1)
	var bottom_cell = grid.get_at_coordinates(bottom_cell_coordinates)
	if (bottom_cell != null && bottom_cell is Root && can_link(root, bottom_cell, "bottom")):
		return true
		
	return false

func _place_cell_things(start_row = 2):
	# On enlève 3 dans les coordonnées pour pouvoir placer le carré
	
	var min_x = 0
	var max_x = grid.size.x - 3
	
	for cell_thing_index in range(cell_things_spawn_number_in_base_sprite):
		var x = rng.randi_range(min_x, max_x)
		var y = rng.randi_range(start_row, grid.size.y - 3)
		
		var cell_thing_class = _randomize_cell_thing()
		if (y <= 8):
			while cell_thing_class == MayaPlate:
				cell_thing_class = _randomize_cell_thing()
		
		_spawn_cell_things_square(cell_thing_class, Vector2(x, y))

func _place_first_root():
	var first_root = Root.new()
	first_root.randomize_instance()
	var random_cell_under_tree = rng.randi_range(7, 12)
	var first_root_grid_position = Vector2(random_cell_under_tree, 0)
	var first_root_map_position = grid.calculate_map_position(first_root_grid_position)
	first_root.position = first_root_map_position
	$CellThings.add_child(first_root)
	grid.add(first_root)
	
	var selector_grid_position = first_root_grid_position
	selector_grid_position.y += 1
	var selector_map_position = grid.calculate_map_position(selector_grid_position)
	$GridSelector.cell = selector_grid_position
	$GridSelector.position = selector_map_position

func _randomize_cell_thing():
	var random_index = rng.randi_range(0, cell_thing_types.size() - 1)
	var selected_cell_thing = cell_thing_types[random_index]
	
	if (selected_cell_thing == MayaPlate):
		cell_thing_types.remove(random_index)
	
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
		$CellThings.add_child(cell_thing)
		if(grid.cell_is_empty(cell_position)):
			grid.add(cell_thing)
		else:
			$CellThings.remove_child(cell_thing)

		if (i % 3 == 2):
			current_row = current_row + 1

func can_link(root: Root, root_to_link: Root, direction: String) -> bool:
	var root_to_link_links = root_to_link.define_linkable_parts()
	var current_links = root.define_linkable_parts()
	
	return (direction == "left" && current_links.left && root_to_link_links.right) || (direction == "top" && current_links.top && root_to_link_links.bottom) || (direction == "right" && current_links.right && root_to_link_links.left) || (direction == "bottom" && current_links.bottom && root_to_link_links.top)

func _add_underground_layer():
	$UndergroundSprites/Underground.region_rect = $UndergroundSprites/Underground.region_rect.grow_individual(0, 0, 0, rows_to_add_on_trigger * grid.cell_size.y)
	var last_row = grid.size.y
	grid.size.y += rows_to_add_on_trigger
	y_add_layers_trigger += rows_to_add_on_trigger
	_place_cell_things(last_row - 3)
	_limit_camera_bottom()

func _limit_camera_bottom():
	# 500 = décallage vers le bas de l'underground pour placer sous l'arbre
	# 10 = décallage vers le haut pour clipper avec l'herbe
	$GridSelector/Camera2D.limit_bottom = $UndergroundSprites/Underground.region_rect.size.y + 500 - 10
