extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")

func _on_create_root(root: Node2D):
	GAME.set_can_create_root(true)
	var duplicatedRoot = root.duplicate()
	if GAME.check_free_in_grid($GridKinematic.position):
		if (GAME.check_cell_contains_node_type($GridKinematic.position, "sediment")):
			GAME.increment_sediment()
			EVENTS.emit_signal("sediment_linked")
		
		duplicatedRoot.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", duplicatedRoot)
		GAME._add_to_grid($GridKinematic.position, duplicatedRoot)
		GAME.set_can_create_root(true)
		$RootPlacedSound.stop()
		$RootPlacedSound.play()
	else: 
		if GAME.check_cell_contains_node_type($GridKinematic.position, "rock"):
			$RootPlacedForbiddenSound.stop()
			$RootPlacedForbiddenSound.play()
		GAME.set_can_create_root(false)
