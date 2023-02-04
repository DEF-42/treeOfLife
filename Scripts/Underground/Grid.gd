extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")
	_register_rocks()
	_register_sediments()

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
	else: GAME.set_can_create_root(false)

func _register_rocks():
	for rock in $RockGroup.get_children():
		# Pourquoi il y a 500px qui trainent sur le y ?!
		GAME._add_to_grid(Vector2(rock.global_position.x, rock.global_position.y - 500), rock)

func _register_sediments():
	for sediment in $SedimentGroup.get_children():
		# Pourquoi il y a 500px qui trainent sur le y ?!
		GAME._add_to_grid(Vector2(sediment.global_position.x, sediment.global_position.y - 500), sediment)
