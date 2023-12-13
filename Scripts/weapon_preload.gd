extends Node

var gun_scn: PackedScene = preload("res://Scenes/Gun.tscn")
var money_scn: PackedScene = preload("res://Scenes/Money.tscn")
onready var player = get_tree().get_nodes_in_group("player")[0]

export (String, FILE, "*.json") var weapon_file_path : String

func _ready() -> void:
	if !globals.level > 1:
		globals.weapons = globals.load_weapons(weapon_file_path)
		globals.weapons_left_to_choose = globals.weapons.duplicate(true)
