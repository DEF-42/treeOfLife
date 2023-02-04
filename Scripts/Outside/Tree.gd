extends Node2D


var sprite_path: String = "res://Assets/Outside/Arbre/grosArbre.png"


func _ready():
	$ArbreArea/Arbre.texture = load(sprite_path)
	EVENTS.connect("hurt_tree", self, "_on_hurt_tree")

func _process(_delta):
	$ArbreArea/Arbre.texture = load(sprite_path)


### SIGNALS ###
func _on_hurt_tree(spritePath: String):
	$ArbreArea/Arbre/AnimationPlayer.play("hurt")
	$HurtTree.play()
	sprite_path = spritePath
