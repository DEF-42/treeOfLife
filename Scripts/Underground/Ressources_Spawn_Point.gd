extends Node2D

export var resource_type: String

var resource_scene = preload("res://Scenes/Underground/Ressource.tscn")
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	var minimum = 1
	var maximum = 9
	if (resource_type == GAME.MAYA_PLATE):
		maximum = 1
	var resource_number = rng.randi_range(minimum, maximum)
	
	var current_row = 0
	for i in range(0, resource_number):
		var x = (i % 3) * GAME.cell_size.x
		var y = current_row * GAME.cell_size.y
		
		var skip = false
		if (i > minimum):
			skip = rng.randi_range(0, 1)
			if (skip == 1):
				continue
		
		var resource_instance = resource_scene.instance()
		resource_instance.type = resource_type
		resource_instance.translate(Vector2(x, y))
		$".".add_child(resource_instance)
		
		var global_position = Vector2(resource_instance.global_position.x, resource_instance.global_position.y - 500)
		if (!GAME.check_free_in_grid(global_position, false)):
			resource_instance.queue_free()
			continue
		
		GAME._add_to_grid(global_position, resource_instance)
		if (i % 3 == 2):
			current_row = current_row + 1
