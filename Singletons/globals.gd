extends Node

# Couleur Orange des menus au focus : #ff7921

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
var total_coins_collected: int = 1000

var weapons_left_to_choose: Dictionary
var weapons: Dictionary

var player_weapon: String
var hud: Array
var center_touched: bool = false
var last_area: Node


# DEBUFF RELATED
var base_burn_timer: int = 1
var base_tick_burn: float = 0.5

@export var weapon_file_path : String # (String, FILE, "*.json")

var upgrades: Dictionary = {
	"Explo1" : {
		"name" : "Explosivity",
		"level" : 0,
		"max_level" : 2,
		"price" : [10, 25],
		"description" : "This card's effect doubles/quadruples the radius of explosions.",
		"effect" : [2, 4, 6],
		"locked" : false,
		"next_upgrade" : "Explo2"
	},
	"Explo2" : {
		"name" : "Atomic Bomb",
		"level" : 0,
		"max_level" : 5,
		"price" : [100, 120, 150, 200, 260],
		"description" : "Adds a multiplier to 3/7/10/20/40x more base damage to explosions.",
		"effect" : [1, 3, 7, 10, 20, 40],
		"locked" : true,
		"next_upgrade" : ""
	}
}

var active_buffs: Dictionary = {
	"attack_raw" : {
		"level" : 0,
		"description" : "Adds +1 to base damage",
		"sprite" : "res://Sprites/Buffs/attack_raw.png"
	},
	"attack_multiplier" : {
		"level" : 0,
		"description" : "Adds 10% to damage multiplier",
		"sprite" : "res://Sprites/Buffs/attack_multiplier.png"
	},
	"piercing" : {
		"level" : 0,
		"description" : "Bullet pierce depending on level",
		"sprite" : "res://Sprites/Buffs/pierce_buff.png"
	},
	"fire" : {
		"level" : 0,
		"description" : "Burn the enemy over time",
		"sprite" : "res://Sprites/Buffs/fire_buff.png"
	},
	"explosive" : {
		"level" : 0,
		"description" : "Bullet explode on impact",
		"sprite" : "res://Sprites/Buffs/Explo1.png"
	}
}

var music_settings: Dictionary

signal end_level

func _ready() -> void:
	load_weapons(weapon_file_path)
	music_initialization()

func get_active_buff_level(name: String) -> int:
	var buff_level: int = active_buffs[name].level
	return buff_level

func reset_active_buffs() -> void:
	for buff in active_buffs:
		active_buffs[buff].level = 0

func get_upgrade_level(name: String) -> int:
	var upgrade_level: int = upgrades[name].level
	return upgrade_level

func get_upgrade_price(name: String) -> int:
	var upgrade_price: int = upgrades[name].price[get_upgrade_level(name)]
	return upgrade_price

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

func music_initialization() -> void:
	for music in get_children():
		if music is AudioStreamPlayer:
			music_settings[music.name] = { "normal_volume" : music.volume_db }

func reset_music_volume(node_name: String) -> void:
	for music in get_children():
		if music.name == node_name:
			music.volume_db = music_settings[music.name].normal_volume
