extends Node2D


func _ready():
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
		EVENTS.emit_signal("activate_enemy_spawner")
