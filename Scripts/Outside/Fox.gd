extends KinematicBody2D


export var speed: int = 10
export var hp: int = 3

var direction = Vector2.ZERO


func _ready():
	$FoxWalk.play()
	$Sprite/AnimationPlayer.play("walk")
	direction.x = direction.x - speed

func _process(delta):
	if global_position.x <= 500:
		direction.x = direction.x + speed
		$Sprite.set_flip_h(true)
	elif global_position.x >= 1075:
		direction.x = direction.x - speed
		$Sprite.set_flip_h(false)
	var collision = move_and_collide(speed * direction * delta)
	
	if collision:
		if collision.collider.name == "EnemyKinematic":
			EVENTS.emit_signal("kill_enemy")
			EVENTS.emit_signal("display_battle", collision.position)
			hp = hp - 1
		if collision.collider.name == "BeaverKinematic":
			hp = hp - 1
			
	if hp == 0:
		$".".queue_free()
