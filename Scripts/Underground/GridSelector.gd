extends KinematicBody2D


var direction = Vector2.ZERO
var speed = 0
var velocity = Vector2.ZERO

const TOP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)


func _process(_delta):
	var is_moving = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")
	
	if is_moving:
		speed = 80
		if Input.is_action_just_pressed("ui_up"):
			if global_position.y > 500:
				direction = TOP
			else: direction = Vector2.ZERO
		if Input.is_action_just_pressed("ui_down"):
			direction = DOWN
		if Input.is_action_just_pressed("ui_left"):
			if global_position.x > 0:
				direction = LEFT
			else: direction = Vector2.ZERO
		if Input.is_action_just_pressed("ui_right"):
			if global_position.x < 1520:
				direction = RIGHT
			else: direction = Vector2.ZERO
	else: speed = 0
	
	velocity = speed * direction
	
	move_and_collide(velocity)
