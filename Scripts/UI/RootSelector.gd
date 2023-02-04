extends Node2D


var can_create_root: bool = true
var root_I_sprite = preload("res://Assets/Underground/root_I.png")
var root_L_sprite = preload("res://Assets/Underground/root_L.png")
var root_T_sprite = preload("res://Assets/Underground/root_T.png")
var root_dictionary = {
	1: root_I_sprite,
	2: root_L_sprite,
	3: root_T_sprite,
}
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	_randomize_roots()
	Input.action_press("first_root")

func _process(delta):
	if Input.is_action_just_pressed("first_root"):
		_create_root($RootsGroup/Root)
	if Input.is_action_just_pressed("second_root"):
		_create_root($RootsGroup/Root2)
	if Input.is_action_just_pressed("third_root"):
		_create_root($RootsGroup/Root3)


func _create_root(root: Node2D):
	EVENTS.emit_signal("create_root", root)
	if GAME.get_can_create_root():
		_randomize_roots()

func _randomize_roots():
	for root in $RootsGroup.get_children():
		var root_sprite = root.get_child(0)
		root.get_child(0).texture = _get_random_root_texture()
		root.rotate(_get_random_root_rotation())
	
func _get_random_root_texture() -> StreamTexture:
	var random_number = rng.randi_range(1, root_dictionary.size())
	return root_dictionary.get(random_number)
	
func _get_random_root_rotation() -> float:
	var random_number = rng.randi_range(0, 3)
	return deg2rad(90 * random_number)
