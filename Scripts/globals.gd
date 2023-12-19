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

var second_loot_table: Dictionary = {
	0: {
		"Coin": 15,
		"Cloth": 5,
		"ZombieCard": 0.05
	},
	1: {
		"Coin": 40,
		"Cloth": 18,
		"MegaZombieCard": 0.01
	}
}

var item_dictionary: Dictionary = {
	"Coin": {
		"ID": 1,
		"Description": "A simple gold coin."
	},
	"Cloth": {
		"ID": 2,
		"Description": "That thing smells very bad. Maybe I could craft something with it."
	},
	"ZombieCard": {
		"ID": 3,
		"Description": "ATK +3 on all zombie type monsters",
		"Effect": "..."
	}
}


signal end_level

func _ready() -> void:
	load_weapons(weapon_file_path)


# FUNCTION TO TEST THE DROP TO CALL IN READY
#func died() -> void:
#	for item in second_loot_table[id]:
#		var rng = RandomNumberGenerator.new()
#		rng.randomize()
#		var roll = rng.randf_range(0, 10)
#		if roll <= second_loot_table[id][item]:
#			print("Item: " + str(item) +  " has been droppped by monster ID: " + str(id))



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
	spawn_to_destroy -= 1
	if spawn_to_destroy <= 0:
		emit_signal("end_level")
