extends KinematicBody2D

export var speed: int = 10
export var spawner = "AllyLeftSpawner"

var direction = Vector2.ZERO


func _ready():
	$Sprite/AnimationPlayer.play("walk")
	EVENTS.connect("kill_ally", self, "_on_kill_ally")

func _physics_process(delta):
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
			_kill()
			EVENTS.emit_signal("kill_enemy")
			EVENTS.emit_signal("display_battle", collision.position)
		if collision.collider.name == "BeaverKinematic":
			_kill()
		if collision.collider.name == "AllyDespawnerKinematic":
			_kill()


### FUNCTIONS ###
func _kill():
	$".".queue_free()


### SIGNALS ###
func _on_kill_ally():
	_kill()
