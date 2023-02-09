extends Node2D


var battle := preload("res://Scenes/Outside/Battle.tscn")
var battleSpawner: Node2D

var rng = RandomNumberGenerator.new()


func _ready():
	GAME.init_game()
	rng.randomize()
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	EVENTS.connect("water_linked", self, "_on_water_linked")
	EVENTS.connect("display_battle", self, "_on_display_battle")
	EVENTS.connect("finish_battle", self, "_on_finish_battle")

func _process(_delta):
	if GAME.get_tree_hp() == 0:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	if Input.is_action_just_pressed("spawn_ally_left"):
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyLeftSpawner)
	if Input.is_action_just_pressed("spawn_ally_right"):
		EVENTS.emit_signal("activate_ally_spawner", $AllySpawners/AllyRightSpawner)
	if Input.is_action_just_pressed("open_shop"):
		$UIContainer/UnitsMarket.set_visible(!$UIContainer/UnitsMarket.visible)


func _createEnemyInstance():
	var random_number = rng.randi_range(1, 4)
	if random_number < 3:
		EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyLeftSpawner)
	else: EVENTS.emit_signal("activate_enemy_spawner", $EnemySpawners/EnemyRightSpawner)


### SIGNALS ###
func _on_day_state_changed(state: bool):
	if state:
		GAME.increment_passed_nights()
	else:
		_createEnemyInstance()
		yield(get_tree().create_timer(9.0), "timeout")
		_createEnemyInstance()
		yield(get_tree().create_timer(9.0), "timeout")
		_createEnemyInstance()

func _on_display_battle(position):
	if is_instance_valid(battleSpawner):
		battleSpawner.queue_free()
	var instance = battle.instance()
	instance.set_position(position)
	battleSpawner = instance
	$".".add_child(instance)

func _on_finish_battle():
	battleSpawner.queue_free()

func _on_water_linked():
	pass
