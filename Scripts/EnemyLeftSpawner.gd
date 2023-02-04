extends Node2D


var termite = preload("res://Scenes/Outside/Enemy.tscn")


func _ready():
	EVENTS.connect("activate_enemy_spawner", self, "_on_activate_enemy_spawner")
	EVENTS.connect("kill_enemy", self, "_on_kill_enemy")


### SIGNALS ###
func _on_activate_enemy_spawner():
	var instance = termite.instance()
	add_child(instance)

func _on_kill_enemy():
	var enemy = $".".get_children()[0]
	enemy.queue_free()
