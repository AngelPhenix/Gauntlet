extends Control

@export var weapon_file_path : String # (String, FILE, "*.json")

var weaponpanel_scn: PackedScene = preload("res://Scenes/PanelWeaponChoosing.tscn")
var weapon_to_choose_from: Dictionary 

# panel size * 3 => 80*3 = 240
# 20 pixels in between *2 => 40
# windows size - (total calculated) => 320 - 280 = 40/2 => 20px 

func _ready():
	randomize()
	weapon_to_choose_from = globals.weapons_left_to_choose.duplicate(true)
	
	for i in range(3):
		var rdm_number = randi() % len(weapon_to_choose_from)
		var weapon_name = weapon_to_choose_from.keys()[rdm_number]
		var new_panel: Panel = weaponpanel_scn.instantiate()
		new_panel.weapon_name_chosen = weapon_name
		new_panel.get_node("VBoxContainer/TextureRect").texture = load(weapon_to_choose_from[weapon_name]["png_path"])
		weapon_to_choose_from.erase(weapon_name)
		add_child(new_panel)
		await get_tree().idle_frame

	for i in len(get_children()):
		var node_to_move = get_children()[i]
		var tween = Tween.new()
		add_child(tween)
		match i:
			0:
				tween.interpolate_property(node_to_move, "position", node_to_move.position, Vector2(20,85), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			1:
				tween.interpolate_property(node_to_move, "position", node_to_move.position, Vector2(120,85), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			2:
				tween.interpolate_property(node_to_move, "position", node_to_move.position, Vector2(220,85), 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		get_tree().get_nodes_in_group("card_sound")[0].play()
		tween.start()
		await tween.tween_completed
		tween.queue_free()
