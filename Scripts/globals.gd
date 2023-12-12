extends Node

var coin_scn: PackedScene = preload("res://Scenes/Coin.tscn")
var zombie_possible_items: Array = [coin_scn]
var weapons_left_to_choose: Dictionary
var weapons: Dictionary
var spawn_to_destroy: int 
var level: int = 1

# SAVED VALUES WHEN TELEPORTER IS STEPPED ON
var player_weapons_in_inventory: Array
var player_equipped_weapon: String
var hud: Array
var total_coins_collected: int = 0

signal end_level

# On return sous la forme de dictionnaire le fichier avec le JSON contenant les armes et leurs caractéristiques.
func load_weapons(file_path: String) -> Dictionary:
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var weapons = parse_json(file.get_as_text())
	assert(weapons.size() > 0) 
	return weapons

func destroyed_spawn() -> void:
	spawn_to_destroy -= 1
	if spawn_to_destroy <= 0:
		emit_signal("end_level")
