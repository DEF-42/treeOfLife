extends Node2D

const MAX_REFRESH = 3

var is_day = true
var rng = RandomNumberGenerator.new()
var available_refresh_counter: int = 0 setget set_available_refresh_counter, get_available_refresh_counter
var current_selection = null


func _ready():
	rng.randomize()
	_randomize_all_roots()
	set_available_refresh_counter(MAX_REFRESH)
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	EVENTS.connect("root_placed", self, "_on_root_placed")
	$Root1.randomize_instance()
	$Root2.randomize_instance()
	$Root3.randomize_instance()
	_select_root($Root1)

func _process(delta):
	if Input.is_action_just_pressed("first_root"):
		_select_root($Root1)
	if is_day && Input.is_action_just_pressed("second_root"):
		_select_root($Root2)
	if is_day && Input.is_action_just_pressed("third_root"):
		_select_root($Root3)
	if Input.is_action_just_pressed("refresh_roots"):
		if get_available_refresh_counter() == 0:
			return
		$RefreshRoots.play()
		_randomize_all_roots()
		EVENTS.emit_signal("select_root", current_selection)
		_decrement_available_refresh_counter()


### SIGNALS ###
func _on_day_state_changed(_is_day: bool):
	is_day = _is_day
	if _is_day:
		set_available_refresh_counter(MAX_REFRESH)
		$Root2.set_modulate("ffffff")
		$Root3.set_modulate("ffffff")
	else:
		$Root2.set_modulate("4ae8d6d6")
		$Root3.set_modulate("4ae8d6d6")

func _on_root_placed():
	current_selection.randomize_instance()
	EVENTS.emit_signal("select_root", current_selection)


### FUNCTIONS ###
func _select_root(root: Node2D):
	if (current_selection == root):
		EVENTS.emit_signal("try_place_root", current_selection)
	else:
		current_selection = root
		$Selection.position = root.position
		EVENTS.emit_signal("select_root", root)

func _randomize_all_roots():
	for root in [$Root1, $Root2, $Root3]:
		root.randomize_instance()

func _decrement_available_refresh_counter():
	set_available_refresh_counter(get_available_refresh_counter() - 1)

### GETTERS / SETTERS ###
func set_available_refresh_counter(val: int):
	if val != available_refresh_counter:
		available_refresh_counter = val
		$AvailableRefreshCounter.text = str(val)
func get_available_refresh_counter() -> int:
	return available_refresh_counter
