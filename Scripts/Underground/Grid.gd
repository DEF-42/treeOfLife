extends Node2D

const root_placed_on_rock := preload("res://Sounds/UI/SFX_Placer_Interdit_Rock.wav")
const root_placed_on_root := preload("res://Sounds/UI/SFX_Placer_Interdit_Racine.wav")
const root_placed_on_dirt := preload("res://Sounds/UI/SFX_Placer_Racine_2.wav")
const root_placed_on_sediment := preload("res://Sounds/UI/sediments.wav")
const root_placed_on_mushroom := preload("res://Sounds/UI/Champi.wav")
const root_placed_on_maya_plate := preload("res://Sounds/UI/Maya.wav")
const ressources_spawn_point_scene := preload("res://Scenes/Underground/Ressources_Spawn_Point.tscn")
const ressources_spawn_number = 50
const root_scene := preload("res://Scenes/Underground/Items/Root.tscn")

var root_placed_on_water_variations = {
	1: preload("res://Sounds/UI/SFX_Water_1.wav"),
	2: preload("res://Sounds/UI/SFX_Water_2.wav"),
	3: preload("res://Sounds/UI/SFX_Water_3.wav"),
}
var resource_min_distance = GAME.cell_size.y * 5
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	EVENTS.connect("create_root", self, "_on_create_root")
	_place_first_root()
	
	for i in range(ressources_spawn_number):
		var x = rng.randi_range(0, (1600 - (GAME.cell_size.x * 3)))
		x = x - (x % int(GAME.cell_size.x))
		var y = GAME.cell_size.y * i
		if (y == 0):
			y = GAME.cell_size.y * 3
		else:
			y = y + resource_min_distance
			
		var resource_type = _randomize_resource_type()
		
		if (y <= GAME.cell_size.y * 8):
			while resource_type == GAME.MAYA_PLATE:
				resource_type = _randomize_resource_type()
			
		var spawn_point_instance = ressources_spawn_point_scene.instance()
		spawn_point_instance.resource_type = resource_type
		spawn_point_instance.translate(Vector2(x, y))
		$".".add_child(spawn_point_instance)

func _on_create_root(root: Node2D):
	GAME.set_can_create_root(true)
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
		GAME.set_can_create_root(true)
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
			$RootPlacedForbiddenSound.stream = null
		$RootPlacedForbiddenSound.play()
		GAME.set_can_create_root(false)

func _place_first_root():
	var first_root = root_scene.instance()
	var random_cell_under_tree = rng.randi_range(7, 12)
	first_root.translate(Vector2(40 + GAME.cell_size.x * random_cell_under_tree, + 40))
	first_root.get_child(0).region_rect = GAME._get_random_root_texture(rng)
	var first_root_sprite_type = GAME._get_root_sprite_type(first_root.get_child(0).region_rect.position)
	
	var max_rotations = 0
	if(first_root_sprite_type == "L"):
		max_rotations = 2
	elif(first_root_sprite_type == "T"):
		max_rotations = 3
	
	if (max_rotations > 0):
		var rotation_degrees = rng.randi_range(1, max_rotations) * 90
		first_root.rotate(deg2rad(rotation_degrees))
	
	GAME._define_root_available_link(first_root)
	add_child_below_node($".", first_root)
	GAME._add_to_grid(Vector2(first_root.position.x - 40, first_root.position.y - 40), first_root)
	GAME.set_can_create_root(true)

func _randomize_resource_type() -> String:
	var random_index = rng.randi_range(0, GAME.resource_types.size() - 1)
	var selected_resource = GAME.resource_types[random_index]
	if (selected_resource == GAME.MAYA_PLATE):
		GAME.resource_types.erase(GAME.MAYA_PLATE)
	return selected_resource
