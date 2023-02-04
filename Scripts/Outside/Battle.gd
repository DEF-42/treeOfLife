extends Node2D


func _ready():
	$Sprite/AnimationPlayer.play("battle")


func _on_AnimationPlayer_animation_finished(anim_name):
	EVENTS.emit_signal("finish_battle")
