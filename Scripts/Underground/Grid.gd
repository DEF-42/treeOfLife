extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")
	_register_rocks()

func _on_create_root(texture: StreamTexture):
	GAME.set_can_create_root(true)
	var sprite = Sprite.new()
	sprite.texture = texture
	if GAME.check_free_in_grid($GridKinematic.position):
		sprite.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", sprite)
		GAME.set_can_create_root(true)
	else: GAME.set_can_create_root(false)

func _register_rocks():
	for rock in $RockGroup.get_children():
		# Pourquoi il y a 500px qui trainent sur le y ?!
		GAME._add_to_grid(Vector2(rock.global_position.x, rock.global_position.y - 500))
