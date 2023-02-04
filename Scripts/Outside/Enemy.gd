extends KinematicBody2D


export var speed: int = 10

var direction = Vector2.ZERO


func _process(delta):
	direction = Vector2.ZERO
	direction.x = direction.x + speed
	
	move_and_collide(speed * direction * delta)
