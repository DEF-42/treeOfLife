extends Node2D


var beaver = preload("res://Scenes/Outside/Beaver.tscn")
var termite = preload("res://Scenes/Outside/Enemy.tscn")
var enemySpawner: Node2D
var spawnedBeaver: bool = false


func _ready():
	EVENTS.connect("activate_enemy_spawner", self, "_on_activate_enemy_spawner")
	EVENTS.connect("kill_enemy", self, "_on_kill_enemy")


### SIGNALS ###
func _on_activate_enemy_spawner(spawner: Node2D):
	enemySpawner = spawner
	var instance: Node
	
	if GAME.passed_nights % 3:
		instance = beaver.instance()
		instance.position.y = instance.position.y - 30
	else:
		instance = termite.instance()
	
	spawner.add_child(instance)
	EVENTS.emit_signal("spawn_enemy", spawner.name)

func _on_kill_enemy():
	var enemy = enemySpawner.get_children()[0]
	enemy.queue_free()
