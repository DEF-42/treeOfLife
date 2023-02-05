extends AudioStreamPlayer

const DAY_SOUNDS_VARIATIONS_NUMBER = 5
const NIGHT_SOUNDS_VARIATIONS_NUMBER = 5
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
		$"../AmbientNight".stop()
		$"../AmbientDay".play()
		var variation = rng.randi_range(1, DAY_SOUNDS_VARIATIONS_NUMBER)
		ost = "res://Sounds/OST/Day_Variation" + str(variation) + ".wav"
	else:
		$"../AmbientDay".stop()
		$"../AmbientNight".play()
		var variation = rng.randi_range(1, NIGHT_SOUNDS_VARIATIONS_NUMBER)
		ost = "res://Sounds/OST/Night_Variation" + str(variation) + ".wav"
	$".".stream = load(ost);
	$".".play()
