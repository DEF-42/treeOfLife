extends Node2D


func _process(delta):
	$FourmisNbrLabel.set_text(str(GAME.get_available_ants()))
