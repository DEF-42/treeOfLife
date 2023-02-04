extends Node2D


var battle := preload("res://Scenes/Outside/Battle.tscn")
var battleSpawner: Node2D
var experience: int = 0
var experience_step: int = 10

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	$ExperienceTick.connect("timeout", self, "_on_experience_tick")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	EVENTS.connect("sediment_linked", self, "_on_sediment_linked")
	EVENTS.connect("display_battle", self, "_on_display_battle")
	EVENTS.connect("finish_battle", self, "_on_finish_battle")

func _process(_delta):
	if GAME.get_tree_hp() == 0:
		print("PERDU !")
	if Input.is_action_just_pressed("spawn_ally_left"):
		print("on appui sur Q")
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyLeftSpawner)
	if Input.is_action_just_pressed("spawn_ally_right"):
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyRightSpawner)


### SIGNALS ###
func _on_day_state_changed(state):
	if state:
		pass
	else:
		var random_number = rng.randi_range(1, 4)
		if random_number < 3:
			EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyLeftSpawner)
		else: EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyRightSpawner)
		EVENTS.emit_signal("activate_enemy_spawner")

func _on_display_battle(position):
	var instance = battle.instance()
	instance.set_position(position)
	battleSpawner = instance
	$".".add_child(instance)

func _on_finish_battle():
	battleSpawner.queue_free()

func _on_sediment_linked():
	if ($ExperienceTick.is_stopped()):
		$ExperienceTick.start()

func _on_experience_tick():
	experience = experience + (experience_step * GAME.sediments)
	print("de l'exp !", experience)
