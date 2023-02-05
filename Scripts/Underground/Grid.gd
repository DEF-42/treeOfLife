extends Node2D

const root_placed_on_rock := preload("res://Sounds/UI/SFX_Placer_Interdit_Rock.wav")
const root_placed_on_root := preload("res://Sounds/UI/SFX_Placer_Interdit_Racine.wav")
const root_placed_on_dirt := preload("res://Sounds/UI/SFX_Placer_Racine_2.wav")
const root_placed_on_sediment := preload("res://Sounds/UI/sediments.wav")
#const root_placed_on_mushroom := preload()
#const root_placed_on_maya_plate := preload()
const ressources_spawn_point_scene := preload("res://Scenes/Underground/Ressources_Spawn_Point.tscn")
const ressources_spawn_number = 50
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
	
	for i in range(ressources_spawn_number):
		var spawn_point_instance = ressources_spawn_point_scene.instance()
		var x = rng.randi_range(0, (1600 - (GAME.cell_size.x * 3)))
		x = x - (x % int(GAME.cell_size.x))
		var y = GAME.cell_size.y * i
		if (y == 0):
			y = GAME.cell_size.y
		else:
			y = y + resource_min_distance
		spawn_point_instance.translate(Vector2(x, y))
		$".".add_child(spawn_point_instance)

func _on_create_root(root: Node2D):
	GAME.set_can_create_root(true)
	var duplicatedRoot = root.duplicate()
	if GAME.check_free_in_grid($GridKinematic.position):
		$RootPlacedSound.stop()
				
		if (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.SEDIMENT)):
			GAME.increment_sediment()
			EVENTS.emit_signal("sediment_linked")
			if ($RootPlacedSound.stream != root_placed_on_sediment):
				$RootPlacedSound.stream = root_placed_on_sediment
		
		if (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.WATER)):
			GAME.increment_water()
			EVENTS.emit_signal("water_linked")
			var random_index = rng.randi_range(1, root_placed_on_water_variations.size())
			var stream = root_placed_on_water_variations.get(random_index)
			if ($RootPlacedSound.stream != stream):
				$RootPlacedSound.stream = stream
		
		duplicatedRoot.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", duplicatedRoot)
		GAME._add_to_grid($GridKinematic.position, duplicatedRoot)
		GAME.set_can_create_root(true)
		$RootPlacedSound.play()
	else: 
		$RootPlacedForbiddenSound.stop()
		if GAME.check_cell_contains_node_type($GridKinematic.position, GAME.ROCK):
			if ($RootPlacedForbiddenSound.stream != root_placed_on_rock):
				$RootPlacedForbiddenSound.stream = root_placed_on_rock
		if GAME.check_cell_contains_node_type($GridKinematic.position, GAME.ROOT):
			if ($RootPlacedForbiddenSound.stream != root_placed_on_root):
				$RootPlacedForbiddenSound.stream = root_placed_on_root
		$RootPlacedForbiddenSound.play()
		GAME.set_can_create_root(false)
