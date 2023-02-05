extends Node2D

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$ClickSound.play()
		yield(get_tree().create_timer(0.6), "timeout")
		get_tree().change_scene("res://Scenes/World.tscn")
