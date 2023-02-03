extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("numpad_1"):
		_create_root($Root.texture)
	if Input.is_action_just_pressed("numpad_2"):
		_create_root($Root2.texture)
	if Input.is_action_just_pressed("numpad_3"):
		_create_root($Root3.texture)


func _create_root(texture):
	EVENTS.emit_signal("create_root", texture)
