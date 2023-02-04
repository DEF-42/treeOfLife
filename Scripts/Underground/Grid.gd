extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")


### SIGNALS ###
func _on_create_root(texture: StreamTexture):
	GAME.set_can_create_root(true)
	var sprite = Sprite.new()
	sprite.texture = texture
	if GAME.check_free_in_grid($GridKinematic.position):
		sprite.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
		add_child_below_node($".", sprite)
		GAME.set_can_create_root(true)
	else: GAME.set_can_create_root(false)
