extends KinematicBody2D

export var grid: Resource = preload("res://Resources/Grid.tres")


var direction = Vector2.ZERO
var speed = 0
var velocity = Vector2.ZERO
var cell := Vector2.ZERO setget set_cell

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const HORIZONTAL_MOVEMENT_SOUND = preload("res://Sounds/UI/SFX_Deplacement_Horizontal.wav")
const VERTICAL_MOVEMENT_SOUND = preload("res://Sounds/UI/SFX_Deplacement_Vertical.wav")

### BUILT-IN ###
func _ready():
	$SelectedRoot/AnimationPlayer.play("Blink")
	self.cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)

func _process(_delta):
	var is_moving = Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")
	
	if is_moving:
		$GridSelectorMovement.stop()
		speed = 80
		if Input.is_action_just_pressed("ui_up"):
			$GridSelectorMovement.stream = VERTICAL_MOVEMENT_SOUND
			if self.cell.y > 0:
				self.cell += UP
				direction = UP
			else: direction = Vector2.ZERO
		elif Input.is_action_just_pressed("ui_down"):
			$GridSelectorMovement.stream = VERTICAL_MOVEMENT_SOUND
			self.cell += DOWN
			direction = DOWN
		elif Input.is_action_just_pressed("ui_left"):
			$GridSelectorMovement.stream = HORIZONTAL_MOVEMENT_SOUND
			if self.cell.x > 0:
				self.cell += LEFT
				direction = LEFT
			else: direction = Vector2.ZERO
		elif Input.is_action_just_pressed("ui_right"):
			$GridSelectorMovement.stream = HORIZONTAL_MOVEMENT_SOUND
			if self.cell.x < 19:
				self.cell += RIGHT
				direction = RIGHT
			else: direction = Vector2.ZERO
		$GridSelectorMovement.play()
	else: speed = 0
	
	velocity = speed * direction
	
	move_and_collide(velocity)


### ACCESSORS ###
func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)
