extends KinematicBody2D


export var speed: int = 10

var direction = Vector2.ZERO
var spawner: String

var termite_01_sprite = preload("res://Assets/Outside/Enemy/termite01.png")
var termite_02_sprite = preload("res://Assets/Outside/Enemy/termite02.png")
var termite_03_sprite = preload("res://Assets/Outside/Enemy/termite03.png")
var termite_04_sprite = preload("res://Assets/Outside/Enemy/termite04.png")
var ants_dictionary = {
	1: termite_01_sprite,
	2: termite_02_sprite,
	3: termite_03_sprite,
	4: termite_04_sprite,
}
var rng = RandomNumberGenerator.new()


func _ready():
	$Sprite/AnimationPlayer.play("walk")
	rng.randomize()
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
			GAME.set_tree_hp(GAME.get_tree_hp() - 1)
			EVENTS.emit_signal("kill_enemy")


### SIGNALS ###
func _on_spawn_enemy(enemySpawner: String):
	var random_number = rng.randi_range(1, ants_dictionary.size())
	print(random_number)
	$Sprite.set_texture(ants_dictionary[random_number])
	if enemySpawner == null:
		spawner = "EnemyLeftSpawner"
	else: spawner = enemySpawner
