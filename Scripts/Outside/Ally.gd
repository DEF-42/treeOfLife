extends KinematicBody2D


export var speed: int = 10

var direction = Vector2.ZERO
var spawner: String


func _ready():
	$Sprite/AnimationPlayer.play("walk")
	EVENTS.connect("spawn_ally", self, "_on_spawn_ally")
	var tree_node = get_tree().get_root().get_node("World").get_node("AllySpawners").get_node("FoxSpawner").get_node("Fox").get_node("KinematicBody2D")
	if tree_node:
		add_collision_exception_with(tree_node)

func _process(delta):
	direction = Vector2.ZERO
	if spawner == "AllyLeftSpawner":
		direction.x = direction.x - speed
		$Sprite.set_flip_h(false)
	else:
		direction.x = direction.x + speed
		$Sprite.set_flip_h(true)
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		if collision.collider.name == "EnemyKinematic":
			EVENTS.emit_signal("kill_ally")
			EVENTS.emit_signal("kill_enemy")
			EVENTS.emit_signal("display_battle", collision.position)


### SIGNALS ###
func _on_spawn_ally(allySpawner: String):
	if allySpawner == null:
		spawner = "AllyLeftSpawner"
	else: spawner = allySpawner
