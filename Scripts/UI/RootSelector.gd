extends Node2D


var can_create_root: bool = true
var root_sprite_1 = preload("res://Assets/UI/placeholder_root.png")
var root_sprite_2 = preload("res://Assets/UI/placeholder_root_2.png")
var root_sprite_3 = preload("res://Assets/UI/placeholder_root_3.png")
var root_dictionary = {
	1: root_sprite_1,
	2: root_sprite_2,
	3: root_sprite_3,
}
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()

func _process(delta):
	if Input.is_action_just_pressed("numpad_1"):
		_create_root($Root.texture)
	if Input.is_action_just_pressed("numpad_2"):
		_create_root($Root2.texture)
	if Input.is_action_just_pressed("numpad_3"):
		_create_root($Root3.texture)


func _create_root(texture: StreamTexture):
	EVENTS.emit_signal("create_root", texture)
	if GRID.get_can_create_root():
		_randomize_roots()

func _randomize_roots():
	$Root.texture = _get_random_root()
	$Root2.texture = _get_random_root()
	$Root3.texture = _get_random_root()
	
func _get_random_root() -> StreamTexture:
	var random_number = rng.randi_range(1, root_dictionary.size())
	return root_dictionary.get(random_number)
