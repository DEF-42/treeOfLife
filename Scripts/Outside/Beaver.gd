extends KinematicBody2D


export var hp: int = 2
export var speed: int = 10

var direction = Vector2.ZERO
var spawner: String


func _ready():
	$Sprite/AnimationPlayer.play("wlak")
	EVENTS.connect("spawn_enemy", self, "_on_spawn_enemy")

func _process(delta):
	direction = Vector2.ZERO
	if spawner == "EnemyLeftSpawner":
		direction.x = direction.x + speed
		$Sprite.set_flip_h(false)
	else:
		direction.x = direction.x - speed
		$Sprite.set_flip_h(true)
	var collision = move_and_collide(speed * direction * delta)
	if collision:
		if collision.collider.name == "ArbreArea":
			if GAME.get_tree_mushrooms() == 0:
				# On tue le castor car il ne va pas s'acharner sur l'arbre
				EVENTS.emit_signal("kill_enemy")
				GAME.set_tree_hp(GAME.get_tree_hp() - 1)
				# On change l'état de l'arbre en fonction des dégâts
				EVENTS.emit_signal("hurt_tree", _get_tree_sprite())
			else:
				GAME.decrement_tree_mushrooms()
		if collision.collider.name == "KinematicBody2D":
			EVENTS.emit_signal("kill_ally")
			EVENTS.emit_signal("display_battle", collision.position)
			hp = hp - 1
	if hp == 0:
		EVENTS.emit_signal("kill_enemy")


func _get_tree_sprite() -> String:
	var tree_hp = GAME.get_tree_hp()
	var sprite_path = "res://Assets/Outside/Arbre/grosArbre1HP.png"
	if tree_hp == 3:
		sprite_path = "res://Assets/Outside/Arbre/grosArbre.png"
	elif tree_hp == 2:
		sprite_path = "res://Assets/Outside/Arbre/grosArbre2HP.png"
	return sprite_path

### SIGNALS ###
func _on_spawn_enemy(enemySpawner: String):
	if enemySpawner == null:
		spawner = "EnemyLeftSpawner"
	else: spawner = enemySpawner
