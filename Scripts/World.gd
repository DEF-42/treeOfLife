extends Node2D

func _ready():
	$DayCycle/AnimationPlayer.play("DayCycleRotation")
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")


func _on_day_state_changed(state):
	if state:
		print("jour")
	else:
		print("nuit")
