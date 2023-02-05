extends Node2D

var fourmi = preload("res://Scenes/Outside/Ally.tscn")
var allySpawner: Node2D


func _ready():
	$Sprite/AnimationPlayer.play("flash")
	$Sprite2/AnimationPlayer.play("flash")
	EVENTS.connect("activate_ally_spawner", self, "_on_activate_ally_spawner")
	EVENTS.connect("kill_ally", self, "_on_kill_ally")

func _process(delta):
	# On supprime la fourmi si elle sort de l'écran
	if allySpawner != null:
		if allySpawner.get_children().size() > 0:
			var fourmiKinematic = allySpawner.get_child(0).get_child(0)
			var leftBorder = fourmiKinematic.global_position.x > -80 and fourmiKinematic.global_position.x < -60
			var rightBorder = fourmiKinematic.global_position.x > 1660 and fourmiKinematic.global_position.x < 1680
			if leftBorder or rightBorder:
				allySpawner.get_child(0).queue_free()
				# On peut éventuellement la restacker dans nos ressources
				# GAME.set_available_ants(GAME.get_available_ants() + 1)


### SIGNALS ###
func _on_activate_ally_spawner(spawner: Node2D):
	allySpawner = spawner
	var newAntsNbr = GAME.get_available_ants() - 1
	
	if newAntsNbr > -1:
		GAME.set_available_ants(newAntsNbr)
	
		var instance = fourmi.instance()
		spawner.add_child(instance)
		EVENTS.emit_signal("spawn_ally", spawner.name)

func _on_kill_ally():
	var ally = allySpawner.get_child(0)
	if (ally):
		ally.queue_free()
