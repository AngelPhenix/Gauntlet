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

export (String, FILE, "*.json") var weapon_file_path : String

signal end_level

func _ready() -> void:
	load_weapons(weapon_file_path)

# On return sous la forme de dictionnaire le fichier avec le JSON contenant les armes et leurs caractéristiques.
func load_weapons(file_path: String) -> void:
	var file = File.new()
	assert(file.file_exists(file_path))
	file.open(file_path, file.READ)
	var weapons_from_json = parse_json(file.get_as_text())
	assert(weapons_from_json.size() > 0) 
	weapons = weapons_from_json
	weapons_left_to_choose = weapons.duplicate(true)

func destroyed_spawn() -> void:
	print("Number of spawn to destroy before : " + str(spawn_to_destroy))
	spawn_to_destroy -= 1
	print("Number of spawn to destroy after : " + str(spawn_to_destroy))
	if spawn_to_destroy <= 0:
		emit_signal("end_level")
