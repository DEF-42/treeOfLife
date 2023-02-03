extends Node2D


func _ready():
	EVENTS.connect("create_root", self, "_on_create_root")


func _on_create_root(val):
	print(val)
	var sprite = Sprite.new()
	sprite.texture = val
	sprite.position = Vector2($GridKinematic.position.x + 40, $GridKinematic.position.y + 40)
	print(sprite.position)
	add_child_below_node($".", sprite)
