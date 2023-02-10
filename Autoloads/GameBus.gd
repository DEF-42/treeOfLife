extends Node

const DEFAULT_TREE_HP = 3
const SEDIMENTS_BY_NODE = 10
const DEFAULT_AVAILABLE_ANTS = 3
const DEFAULT_AVAILABLE_FOX = 0

var available_ants: int = DEFAULT_AVAILABLE_ANTS setget set_available_ants, get_available_ants
var available_fox: int = DEFAULT_AVAILABLE_FOX setget set_available_fox, get_available_fox
# True = Jour, False = Nuit
var day_cycle_state: bool = true setget set_day_cycle_state, get_day_cycle_state
var tree_hp: int setget set_tree_hp, get_tree_hp
var sediments: int = 0 setget set_tree_sediments, get_tree_sediments
var water: int = 0
var mushrooms: int = 0
var passed_nights = 0


### ACCESSORS ###
func set_available_ants(val: int):
	if val != available_ants:
		available_ants = val
func get_available_ants() -> int:
	return available_ants

func set_available_fox(val: int):
	if val != available_fox:
		available_fox = val
func get_available_fox() -> int:
	return available_fox

func get_day_cycle_state() -> bool:
	return day_cycle_state
func set_day_cycle_state(val: bool):
	if val != day_cycle_state:
		day_cycle_state = val
		EVENTS.emit_signal("day_state_changed", val)

func set_tree_hp(val: int):
	if val != tree_hp:
		tree_hp = val
func get_tree_hp() -> int:
	return tree_hp

func set_tree_sediments(val: int):
	if val != sediments:
		sediments = val
func get_tree_sediments() -> int:
	return sediments

func set_tree_mushrooms(val: int):
	if val != mushrooms:
		mushrooms = val
func get_tree_mushrooms() -> int:
	return mushrooms

### FUNCTIONS ###
func init_game():
	set_tree_hp(DEFAULT_TREE_HP)
	set_tree_sediments(0)
	set_tree_mushrooms(0)
	set_available_ants(DEFAULT_AVAILABLE_ANTS)
	set_available_fox(DEFAULT_AVAILABLE_FOX)
	set_day_cycle_state(true)

func invert_day_state():
	set_day_cycle_state(!get_day_cycle_state())

func increment_sediment():
	sediments = sediments + SEDIMENTS_BY_NODE

func increment_water():
	water = water + 1

func increment_mushrooms():
	mushrooms = mushrooms + 1
func decrement_tree_mushrooms():
	mushrooms = mushrooms - 1
	if (mushrooms < 0):
		mushrooms = 0
	EVENTS.emit_signal("mushroom_armor_lost", mushrooms)

func increment_passed_nights():
	passed_nights = passed_nights + 1
