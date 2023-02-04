extends Node2D


var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")

func _process(_delta):
	if GAME.get_tree_hp() == 0:
		print("PERDU !")


### SIGNALS ###
func _on_day_state_changed(state):
	if state:
		pass
	else:
		var random_number = rng.randi_range(1, 4)
		if random_number < 3:
			EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyLeftSpawner)
		else: EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyRightSpawner)
