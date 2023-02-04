extends Node2D

var experience: int = 0
var experience_step: int = 10

var rng = RandomNumberGenerator.new()


func _ready():
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	$ExperienceTick.connect("timeout", self, "_on_experience_tick")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	EVENTS.connect("sediment_linked", self, "_on_sediment_linked")

func _process(_delta):
	if GAME.get_tree_hp() == 0:
		print("PERDU !")


### SIGNALS ###
func _on_day_state_changed(state):
	if state:
		pass
	else:
		var random_number = rng.randi_range(1, 6)
		print(random_number)
		if random_number < 4:
			EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyLeftSpawner)
		else: EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyRightSpawner)
		EVENTS.emit_signal("activate_enemy_spawner")

func _on_sediment_linked():
	if ($ExperienceTick.is_stopped()):
		$ExperienceTick.start()

func _on_experience_tick():
	experience = experience + (experience_step * GAME.sediments)
	print("de l'exp !", experience)
