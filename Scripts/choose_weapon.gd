extends Control

@export var weapon_file_path : String # (String, FILE, "*.json")
@export var weaponpanel_scn: PackedScene

func _ready():
	var weapon_to_choose_from: Array 
	randomize()
	
	# Populate weapon_to_choose_from with all the weapons name that exists, in an Array
	for weapon in globals.weapons_left_to_choose.keys():
		weapon_to_choose_from.append(weapon)
	
	# Shuffle to then have "random" 0-1-2 indexes weapons
	weapon_to_choose_from.shuffle()
	
	for index in range(3):
		var weapon_name = weapon_to_choose_from[index]
		var new_panel: Panel = weaponpanel_scn.instantiate()
		new_panel.weapon_name_chosen = weapon_name
		add_child(new_panel)
		get_tree().get_nodes_in_group("weapon_display")[index].texture = load(globals.weapons_left_to_choose[weapon_name].png_path)
		await get_tree().process_frame

	for index in len(get_children()):
		var node_to_move = get_children()[index]
		var tween: Tween = create_tween()
		match index:
			0:
				tween.tween_property(node_to_move, "position", Vector2(20,85), 0.4)
			1:
				tween.tween_property(node_to_move, "position", Vector2(120,85), 0.4)
			2:
				tween.tween_property(node_to_move, "position", Vector2(220,85), 0.4)
		get_tree().get_nodes_in_group("card_sound")[0].play()
		await tween.finished
