extends Node2D


var battle := preload("res://Scenes/Outside/Battle.tscn")
var battleSpawner: Node2D
var experience_step: int = 10

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	$ExperienceTick.connect("timeout", self, "_on_experience_tick")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	EVENTS.connect("sediment_linked", self, "_on_sediment_linked")
	EVENTS.connect("water_linked", self, "_on_water_linked")
	EVENTS.connect("mushroom_linked", self, "_on_mushroom_linked")
	EVENTS.connect("display_battle", self, "_on_display_battle")
	EVENTS.connect("finish_battle", self, "_on_finish_battle")

func _process(_delta):
	if GAME.get_tree_hp() == 0:
		# On laisse le temps de jouer le son de chute de l'arbre
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	if Input.is_action_just_pressed("spawn_ally_left"):
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyLeftSpawner)
	if Input.is_action_just_pressed("spawn_ally_right"):
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyRightSpawner)


func _createEnemyInstance():
	var random_number = rng.randi_range(1, 4)
	if random_number < 3:
		EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyLeftSpawner)
	else: EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyRightSpawner)


### SIGNALS ###
func _on_day_state_changed(state: bool):
	if state:
		pass
	else:
		_createEnemyInstance()
		yield(get_tree().create_timer(9.0), "timeout")
		_createEnemyInstance()
		yield(get_tree().create_timer(9.0), "timeout")
		_createEnemyInstance()

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
	GAME.set_tree_xp(GAME.get_tree_xp() + (experience_step * GAME.sediments))
	print("de l'exp !", GAME.get_tree_xp())

func _on_water_linked():
	print("De l'eau ! ", GAME.water)

func _on_mushroom_linked():
	print("Du champi ! ", GAME.mushrooms)
