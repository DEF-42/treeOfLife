extends KinematicBody2D


export var speed: int = 20

var direction = Vector2.ZERO
var spawner: String


func _ready():
	EVENTS.connect("spawn_enemy", self, "_on_activate_enemy_spawner")

func _process(delta):
	direction = Vector2.ZERO
	if spawner == "EnemyLeftSpawner":
		direction.x = direction.x + speed
		$Sprite.set_flip_h(false)
	else:
		direction.x = direction.x - speed
		$Sprite.set_flip_h(true)
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		if collision.collider.name == "ArbreArea":
			GAME.set_tree_hp(GAME.get_tree_hp() - 1)
			EVENTS.emit_signal("kill_enemy")


### SIGNALS ###
func _on_activate_enemy_spawner(enemySpawner: Node2D):
	if enemySpawner == null:
		spawner = "EnemyLeftSpawner"
	else: spawner = enemySpawner.name
