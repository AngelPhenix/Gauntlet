extends Node

var coin_scn: PackedScene = preload("res://Scenes/Coin.tscn")
var exp_scn: PackedScene = preload("res://Scenes/Experience.tscn")
var bonus_scn: PackedScene = preload("res://Scenes/Bonus.tscn")
var zombie_possible_items: Array = [coin_scn, exp_scn, bonus_scn]
var weapons_left_to_choose: Dictionary
var weapons: Dictionary

# SAVED VALUES WHEN TELEPORTER IS STEPPED ON
var player_weapons_in_inventory: Array
var player_equipped_weapon: String
var hud: Array
var total_coins_collected: int = 0
var center_touched: bool = false
var last_area: Node

export (String, FILE, "*.json") var weapon_file_path : String



var buffs: Dictionary = {
	0 : {
		"name" : "attack_raw",
		"tooltip" : "Adds +1 to base damage",
		"sprite" : "res://Sprites/Buffs/attack_raw.png"
	},
	1 : {
		"name" : "attack_multiplier",
		"tooltip" : "Adds 10% to damage multiplier",
		"sprite" : "res://Sprites/Buffs/attack_multiplier.png"
	},
	2 : {
		"name" : "piercing",
		"tooltip" : "Bullet pierce depending on level",
		"sprite" : "res://Sprites/Buffs/pierce_buff.png"
	},
	3 : {
		"name" : "fire",
		"tooltip" : "Burn the enemy over time",
		"sprite" : "res://Sprites/Buffs/fire_buff.png"
	},
	4 : {
		"name" : "explosive",
		"tooltip" : "Bullet explode on impact",
		"sprite" : "res://Sprites/Buffs/explosive_buff.png"
	}
}

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
