extends Node

# Z-INDEX SORTING :
# 0 : Floor
# 1 : Blood Particles
# 2 : Items On The Ground
# 3 : Player & Enemies (grounded)
# 4 : Flying Enemies
# 5 : Thrown Weapons?

var coin_scn: PackedScene = preload("res://Scenes/Coin.tscn")
var exp_scn: PackedScene = preload("res://Scenes/Experience.tscn")
var zombie_possible_items: Array = [coin_scn, exp_scn]
var weapons_left_to_choose: Dictionary
var weapons: Dictionary

# SAVED VALUES WHEN TELEPORTER IS STEPPED ON
var player_weapons_in_inventory: Array
var player_equipped_weapon: String
var hud: Array
var total_coins_collected: int = 0
var center_touched: bool = false
var last_area: Node

@export var weapon_file_path : String # (String, FILE, "*.json")



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
	#var content = file.get_as_text()
	#return content
	var file = FileAccess.open(file_path, FileAccess.READ)
	assert(file.file_exists(file_path),"Le fichier pour load weapons en JSON n'a pas été trouvé.")
	file.open(file_path, file.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var weapons_from_json = test_json_conv.get_data()
	assert(weapons_from_json.size() > 0) 
	weapons = weapons_from_json
	weapons_left_to_choose = weapons.duplicate(true)
