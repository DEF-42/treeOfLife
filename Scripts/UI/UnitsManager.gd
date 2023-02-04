extends Node2D


func _process(delta):
	$FourmisManager/Sprite/SpawnQLabel.set_text(str(GAME.get_available_ants()))
