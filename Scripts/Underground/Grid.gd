extends Node2D

const ressources_spawn_point_scene := preload("res://Scenes/Underground/Ressources_Spawn_Point.tscn")
const ressources_spawn_number = 50
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
		if (GAME.check_cell_contains_node_type($GridKinematic.position, GAME.SEDIMENT)):
			GAME.increment_sediment()
			EVENTS.emit_signal("sediment_linked")
		
		duplicatedRoot.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", duplicatedRoot)
		GAME._add_to_grid($GridKinematic.position, duplicatedRoot)
		GAME.set_can_create_root(true)
		$RootPlacedSound.stop()
		$RootPlacedSound.play()
	else: 
		if GAME.check_cell_contains_node_type($GridKinematic.position, GAME.ROCK):
			$RootPlacedForbiddenSound.stop()
			$RootPlacedForbiddenSound.play()
		GAME.set_can_create_root(false)
