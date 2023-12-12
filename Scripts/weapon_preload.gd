extends Node

var gun_scn: PackedScene = preload("res://Scenes/Gun.tscn")
var money_scn: PackedScene = preload("res://Scenes/Money.tscn")
onready var player = get_tree().get_nodes_in_group("player")[0]

export (String, FILE, "*.json") var weapon_file_path : String

func _ready() -> void:
	if !globals.level > 1:
		globals.weapons = globals.load_weapons(weapon_file_path)
		globals.weapons_left_to_choose = globals.weapons.duplicate(true)

# globals.weapon_left_to_choose contient le JSON entier. Dictionnaire de taille X armes. Contenant eux-mêmes chacun un dictionnaire
# avec les spécificités de chaque armes.
# Pour accéder aux globals.weapon_left_to_choose, on doit d'abord avoir leur nom, grâce à ".keys()" qui prends la clé et non les valeurs
# Puis, lorsque le nom de l'arme à été choisie, on attrape ses caractéristiques avec "Dic.get(nom_arme)"
func create_weapon(chest_position: Vector2) -> void:
	if globals.weapons_left_to_choose.size() > 0:
		var all_weapons: Array = globals.weapons_left_to_choose.keys()
		var new_weapon_name: String = all_weapons[int(rand_range(0, all_weapons.size()))]
		var created_weapon: Node = gun_scn.instance()
		created_weapon.get_node("sprite").texture = load(globals.weapons[new_weapon_name]["png_path"])
		created_weapon.position = chest_position
		call_deferred("add_child", created_weapon)
		created_weapon.weapon_name = new_weapon_name
		globals.weapons_left_to_choose.erase(new_weapon_name)
	else:
		var created_money = money_scn.instance()
		created_money.position = chest_position
		call_deferred("add_child", created_money)
