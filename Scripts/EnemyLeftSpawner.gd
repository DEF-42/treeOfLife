extends Node2D


var termite = preload("res://Scenes/Outside/Enemy.tscn")
var enemySpawner: Node2D


func _ready():
	EVENTS.connect("activate_enemy_spawner", self, "_on_activate_enemy_spawner")
	EVENTS.connect("kill_enemy", self, "_on_kill_enemy")


### SIGNALS ###
func _on_activate_enemy_spawner(spawner: Node2D):
	print("enemyLeftSpawner", spawner)
	enemySpawner = spawner
	var instance = termite.instance()
	spawner.add_child(instance)
	EVENTS.emit_signal("spawn_enemy", spawner.name)

func _on_kill_enemy():
	var enemy = enemySpawner.get_children()[0]
	enemy.queue_free()
