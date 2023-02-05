extends Node2D


var sprite_path: String = "res://Assets/Outside/Arbre/grosArbre.png"


func _ready():
	$ArbreArea/Arbre.texture = load(sprite_path)
	EVENTS.connect("hurt_tree", self, "_on_hurt_tree")
	EVENTS.connect("mushroom_armor_gained", self, "_on_mushroom_armor_gained")
	EVENTS.connect("mushroom_armor_lost", self, "_on_mushroom_armor_lost")
	EVENTS.connect("maya_plate_found", self, "_on_maya_plate_found")

func _process(_delta):
	$ArbreArea/Arbre.texture = load(sprite_path)


### SIGNALS ###
func _on_hurt_tree(spritePath: String):
	$ArbreArea/Arbre/AnimationPlayer.play("hurt")
	if spritePath == "res://Assets/Outside/Arbre/grosArbre2HP.png":
		$HurtTreeLvl1.play()
	elif spritePath == "res://Assets/Outside/Arbre/grosArbre1HP.png":
		$HurtTreeLvl2.play()
	sprite_path = spritePath

func _on_mushroom_armor_gained():
	$ArbreArea/Arbre/Mushrooms.visible = true
	
func _on_mushroom_armor_lost(remaining):
	$ArbreArea/Arbre/AnimationPlayer.play("hurt")
	if (remaining == 0):
		$ArbreArea/Arbre/Mushrooms.visible = false
	
func _on_maya_plate_found():
	$ArbreArea/Arbre/MayaPlate.visible = true
