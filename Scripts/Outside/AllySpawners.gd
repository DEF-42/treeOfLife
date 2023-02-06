extends Node2D

var fourmi = preload("res://Scenes/Outside/Ant.tscn")
var renard = preload("res://Scenes/Outside/Fox.tscn")
var allySpawner: Node2D


func _ready():
	$Sprite/AnimationPlayer.play("flash")
	$Sprite2/AnimationPlayer.play("flash")
	EVENTS.connect("activate_ally_spawner", self, "_on_activate_ally_spawner")

func _process(delta):
	var new_fox = GAME.get_available_fox() - 1
	if Input.is_action_just_pressed("spawn_fox") and new_fox >= 0:
		var instance = renard.instance()
		$FoxSpawner.add_child(instance)
		GAME.set_available_fox(new_fox)


### SIGNALS ###
func _on_activate_ally_spawner(spawner: Node2D):
	allySpawner = spawner
	var newAntsNbr = GAME.get_available_ants() - 1
	
	if newAntsNbr > -1:
		GAME.set_available_ants(newAntsNbr)
	
		var instance = fourmi.instance()
		instance.get_child(0).spawner = spawner.name
		spawner.add_child(instance)
