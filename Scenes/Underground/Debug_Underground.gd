 extends Node2D

export var grid: Resource = preload("res://Resources/Grid.tres")

func _ready():
	var resources = [Sediment, Mushroom, Water]
	var y = 0
	var x = 0
	
	# ROCKS
	for i in range(2):
		x = i
		var rock_instance = Rock.new()
		rock_instance.variation = x + 1
		
		rock_instance.position = grid.calculate_map_position(Vector2(x, y))
		self.add_child(rock_instance)
	
	y += 1
	
	# Resources
	for resource in resources:
		for i in range(2):
			x = i
			var resource_instance = resource.new()
			resource_instance.variation = x + 1
			
			resource_instance.position = grid.calculate_map_position(Vector2(x, y))
			self.add_child(resource_instance)
		x = 0
		y += 1
	
	var maya_plate_instance = MayaPlate.new()
	maya_plate_instance.position = grid.calculate_map_position(Vector2(x, y))
	self.add_child(maya_plate_instance)
	
	# Roots
	y = 0
	x = 16
	for root_form in range(3):
		for form_variation in range(3):
			for rotation in range(4):
				var root_instance = Root.new()
				root_instance.variation = form_variation + 1
				root_instance.position = grid.calculate_map_position(Vector2(x, y))
				self.add_child(root_instance)
				x += 1
			x = 16
			y += 1
		
#	grid.
