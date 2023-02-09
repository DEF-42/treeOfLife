extends Node2D

const MAX_REFRESH = 3

var is_day = true
var rng = RandomNumberGenerator.new()
var available_refresh_counter: int = 0 setget set_available_refresh_counter, get_available_refresh_counter


func _ready():
	rng.randomize()
	_randomize_all_roots()
	set_available_refresh_counter(MAX_REFRESH)
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")

func _process(delta):
	if Input.is_action_just_pressed("first_root"):
		_create_root($RootsGroup/Root)
	if is_day && Input.is_action_just_pressed("second_root"):
		_create_root($RootsGroup/Root2)
	if is_day && Input.is_action_just_pressed("third_root"):
		_create_root($RootsGroup/Root3)
	if Input.is_action_just_pressed("refresh_roots"):
		if get_available_refresh_counter() == 0:
			return
		$RefreshRoots.play()
		_randomize_all_roots()
		_decrement_available_refresh_counter()


### SIGNALS ###
func _on_day_state_changed(_is_day: bool):
	is_day = _is_day
	if _is_day:
		set_available_refresh_counter(MAX_REFRESH)
		$RootsGroup/Root2.set_modulate("ffffff")
		$RootsGroup/Root3.set_modulate("ffffff")
	else:
		$RootsGroup/Root2.set_modulate("4ae8d6d6")
		$RootsGroup/Root3.set_modulate("4ae8d6d6")


### FUNCTIONS ###
func _create_root(root: Node2D):
	EVENTS.emit_signal("create_root", root)
#		_randomize_root(root)

func _randomize_all_roots():
	for root in [$Root1, $Root2, $Root3]:
		root.randomize_instance()
	
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
