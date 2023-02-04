extends Node2D


var termite = preload("res://Scenes/Outside/Enemy.tscn")


func _ready():
	var instance = termite.instance()
	add_child(instance)
