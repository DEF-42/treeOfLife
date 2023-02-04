extends KinematicBody2D


export var speed: int = 10

var direction = Vector2.ZERO


func _process(delta):
	direction = Vector2.ZERO
	direction.x = direction.x + speed
	
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		if collision.collider.name == "ArbreArea":
			GAME.set_tree_hp(GAME.get_tree_hp() - 1)
			EVENTS.emit_signal("kill_enemy")
