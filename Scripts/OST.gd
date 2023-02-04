extends AudioStreamPlayer

const DAY_SOUNDS = {
	1: preload("res://Sounds/OST/Day_Variation1.wav"),
	2: preload("res://Sounds/OST/Day_Variation2.wav"),
	3: preload("res://Sounds/OST/Day_Variation3.wav"),
}
var DAY_SOUNDS_SIZE = DAY_SOUNDS.size()
const NIGHT_SOUNDS = {
	1: preload("res://Sounds/OST/Night_Variation1.wav"),
	2: preload("res://Sounds/OST/Night_Variation2.wav"),
	3: preload("res://Sounds/OST/Night_Variation3.wav"),
}
var NIGHT_SOUNDS_SIZE = NIGHT_SOUNDS.size()
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	EVENTS.connect("day_state_changed", self, "_on_day_state_changed")
	_randomize_ost(1)
	
func _on_day_state_changed(state: bool):
	_randomize_ost(state)


### FUNCTIONS ###
func _randomize_ost(state: bool):
	var ost;
	if (state):
		ost = DAY_SOUNDS.get(rng.randi_range(1, DAY_SOUNDS_SIZE))
	else:
		ost = NIGHT_SOUNDS.get(rng.randi_range(1, NIGHT_SOUNDS_SIZE))
	$".".stream = ost;
	$".".play()
