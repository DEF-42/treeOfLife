extends Node2D

var fourmi = preload("res://Scenes/Outside/Ally.tscn")
var allySpawner: Node2D


func _ready():
	$SpawnQLabel/AnimationPlayer.play("flash")
	$SpawnDLabel/AnimationPlayer.play("flash")
	EVENTS.connect("activate_ally_spawner", self, "_on_activate_ally_spawner")
	EVENTS.connect("kill_ally", self, "_on_kill_ally")


### SIGNALS ###
func _on_activate_ally_spawner(spawner: Node2D):
	allySpawner = spawner
	var instance = fourmi.instance()
	spawner.add_child(instance)
	print("allySpawnerNode", spawner)
	EVENTS.emit_signal("spawn_ally", spawner.name)

func _on_kill_ally():
	var ally = allySpawner.get_children()[0]
	ally.queue_free()
