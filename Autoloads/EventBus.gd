extends Node


signal create_root(texture)
signal sediment_linked()
signal water_linked()
signal maya_plate_found()
signal mushroom_armor_gained()
signal mushroom_armor_lost()

signal day_state_changed(state)

signal activate_enemy_spawner(spawner)
signal kill_enemy()
signal spawn_enemy(spawnerName)

signal kill_ally()
signal activate_ally_spawner(spawner)
signal spawn_ally(spawnerName)

signal display_battle(position)
signal finish_battle()

signal hurt_tree(treeSprite)
