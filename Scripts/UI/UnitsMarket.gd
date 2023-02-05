extends Node2D


func _process(delta):
	$Sprite/RoundUi/SedimentsLabelNbr.set_text(str(GAME.get_tree_sediments()))
	if GAME.get_tree_sediments() > 0:
		if Input.is_action_just_pressed("buy_ants"):
			GAME.set_tree_sediments(GAME.get_tree_sediments() - 2)
			GAME.set_available_ants(GAME.get_available_ants() + 1)
		if Input.is_action_just_pressed("buy_fox"):
			GAME.set_tree_sediments(GAME.get_tree_sediments() - 6)
			GAME.set_available_fox(GAME.get_available_fox() + 1)
