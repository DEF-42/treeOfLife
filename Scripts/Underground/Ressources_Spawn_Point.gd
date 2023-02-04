extends Node2D

var resource_scene = preload("res://Scenes/Underground/Ressource.tscn")
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	var resource_type = _randomize_resource_type()
	var resource_number = rng.randi_range(1, 9)
	
	var current_row = 0
	for i in range(0, resource_number):
		var x = (i % 3) * 80
		var y = current_row * 80
		var resource_instance = resource_scene.instance()
		resource_instance.type = resource_type
		print("x ", x, " y ", y)
		resource_instance.translate(Vector2(x, y))
		$".".add_child(resource_instance)
		GAME._add_to_grid(Vector2(resource_instance.global_position.x, resource_instance.global_position.y - 500), resource_instance)
		if (i % 3 == 2):
			current_row = current_row + 1

func _randomize_resource_type() -> String:
	var random_index = rng.randi_range(0, GAME.resource_types.size() - 1)
	var selected_resource = GAME.resource_types[random_index]
	GAME.resource_types.erase(selected_resource)
	return selected_resource