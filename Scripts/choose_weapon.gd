extends Control

@export var weapon_file_path : String # (String, FILE, "*.json")

var weaponpanel_scn: PackedScene = preload("res://Scenes/PanelWeaponChoosing.tscn")
var weapon_to_choose_from: Array 

# panel size * 3 => 80*3 = 240
# 20 pixels in between *2 => 40
# windows size - (total calculated) => 320 - 280 = 40/2 => 20px 

func _ready():
	randomize()
	
	# Populate weapon_to_choose_from with all the weapons name that exists, in an Array
	for weapon in globals.weapons_left_to_choose.keys():
		weapon_to_choose_from.append(weapon)
	
	# Shuffle to then have "random" 0-1-2 indexes weapons
	weapon_to_choose_from.shuffle()
	
	for i in range(3):
		var weapon_name = weapon_to_choose_from[i]
		var new_panel: Panel = weaponpanel_scn.instantiate()
		new_panel.weapon_name_chosen = weapon_name
		new_panel.get_node("VBoxContainer/TextureRect").texture = load(globals.weapons_left_to_choose[weapon_name]["png_path"])
		add_child(new_panel)
		await get_tree().process_frame

	for i in len(get_children()):
		var node_to_move = get_children()[i]
		var tween: Tween = create_tween()

		match i:
			0:
				tween.tween_property(node_to_move, "position", Vector2(20,85), 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			1:
				tween.tween_property(node_to_move, "position", Vector2(120,85), 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			2:
				tween.tween_property(node_to_move, "position", Vector2(220,85), 0.4).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		get_tree().get_nodes_in_group("card_sound")[0].play()
		await tween.finished
