extends Node2D

const MAX_REFRESH = 3

var can_create_root: bool = true
var can_rotate_root: bool = false
var root_I_sprite = preload("res://Assets/Underground/root_I.png")
var root_L_sprite = preload("res://Assets/Underground/root_L.png")
var root_T_sprite = preload("res://Assets/Underground/root_T.png")
var root_dictionary = {
	1: root_I_sprite,
	2: root_L_sprite,
	3: root_T_sprite,
}
var rng = RandomNumberGenerator.new()
var available_refresh_counter: int = 0 setget set_available_refresh_counter, get_available_refresh_counter


func _ready():
	rng.randomize()
	_randomize_all_roots()
	can_rotate_root = true
	set_available_refresh_counter(MAX_REFRESH)
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")

func _process(delta):
	if Input.is_action_just_pressed("first_root"):
		_create_root($RootsGroup/Root)
	if Input.is_action_just_pressed("second_root"):
		_create_root($RootsGroup/Root2)
	if Input.is_action_just_pressed("third_root"):
		_create_root($RootsGroup/Root3)
	if Input.is_action_just_pressed("refresh_roots"):
		if get_available_refresh_counter() == 0:
			return
		_randomize_all_roots()
		_decrement_available_refresh_counter()


### SIGNALS ###
func _on_day_state_changed(state: bool):
	if state:
		set_available_refresh_counter(MAX_REFRESH)


### FUNCTIONS ###
func _create_root(root: Node2D):
	EVENTS.emit_signal("create_root", root)
	if GAME.get_can_create_root():
		_randomize_root(root)

func _randomize_root(root: Node2D):
	var root_sprite = root.get_child(0)
	root.get_child(0).texture = _get_random_root_texture()
	if can_rotate_root:
		root.rotate(_get_random_root_rotation())

func _randomize_all_roots():
	for root in $RootsGroup.get_children():
		_randomize_root(root)
	
func _get_random_root_texture() -> StreamTexture:
	var random_number = rng.randi_range(1, root_dictionary.size())
	return root_dictionary.get(random_number)
	
func _get_random_root_rotation() -> float:
	var random_number = rng.randi_range(0, 3)
	return deg2rad(90 * random_number)

func _decrement_available_refresh_counter():
	set_available_refresh_counter(get_available_refresh_counter() - 1)


### GETTERS / SETTERS ###
func set_available_refresh_counter(val: int):
	if val != available_refresh_counter:
		available_refresh_counter = val
		$AvailableRefreshCounter.text = str(val)
func get_available_refresh_counter() -> int:
	return available_refresh_counter
