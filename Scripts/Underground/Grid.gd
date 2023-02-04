extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")
	_register_resources()

func _on_create_root(root: Node2D):
	GAME.set_can_create_root(true)
	var duplicatedRoot = root.duplicate()
	if GAME.check_free_in_grid($GridKinematic.position):
		if (GAME.check_cell_contains_sediment($GridKinematic.position)):
			GAME.increment_sediment()
			EVENTS.emit_signal("sediment_linked")
		
		duplicatedRoot.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", duplicatedRoot)
		GAME._add_to_grid($GridKinematic.position, duplicatedRoot)
		GAME.set_can_create_root(true)
		$RootPlacedSound.stop()
		$RootPlacedSound.play()
	else: GAME.set_can_create_root(false)

func _register_resources():
	var AVAILABLE_RESOURCES = [$RockGroup, $SedimentGroup, $WaterGroup]
	for resource_type in AVAILABLE_RESOURCES:
		for resource in resource_type.get_children():
			# 500px de décalage du grid
			GAME._add_to_grid(Vector2(resource.global_position.x, resource.global_position.y - 500), resource)
