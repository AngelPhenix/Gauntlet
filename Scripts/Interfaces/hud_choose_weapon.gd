extends Control

var all_weapons: Array

@export var weapon_card_scn: PackedScene
@onready var player : Node = get_tree().get_nodes_in_group("player")[0]

func _ready():
	_prepare_weapon_array()
	
	for index in range(3):
		var weapon: String = all_weapons[index]
		var weapon_card: Panel = weapon_card_scn.instantiate()
		weapon_card.weapon_name = weapon
		add_child(weapon_card)
		weapon_card.weapon_chosen.connect(_on_weapon_chosen)

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

func _prepare_weapon_array() -> void:
	for weapon in globals.weapons.keys():
		all_weapons.append(weapon)
	all_weapons.shuffle()

func _on_weapon_chosen(weapon_name) -> void:
	player.equip(weapon_name)
	get_tree().paused = false
	get_tree().get_nodes_in_group("choose_weapon_hud")[0].queue_free()
