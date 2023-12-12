extends StaticBody2D

var player_in_area: bool = false
var opened: bool = false
var opened_chest_texture: StreamTexture = preload("res://Sprites/weapon_chest_open.png")
onready var weapon_preload: Node = get_tree().get_nodes_in_group("wp_preload")[0]

# CHEST ITEM GENERATIONS
var gun_scn: PackedScene = preload("res://Scenes/Gun.tscn")
var money_scn: PackedScene = preload("res://Scenes/Money.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && !opened && player_in_area:
		weapon_preload.create_weapon(position)
		opened = true
		($sprite as Sprite).texture = opened_chest_texture
		$opening.play()
		set_process(false)


func create_weapon(chest_position: Vector2) -> void:
	if globals.weapons_left_to_choose.size() > 0:
		var all_weapons: Array = globals.weapons_left_to_choose.keys()
		var new_weapon_name: String = all_weapons[int(rand_range(0, all_weapons.size()))]
		var created_weapon: Node = gun_scn.instance()
		created_weapon.get_node("sprite").texture = load(globals.weapons[new_weapon_name]["png_path"])
		created_weapon.global_position = chest_position
		add_child(created_weapon)
		created_weapon.weapon_name = new_weapon_name
		globals.weapons_left_to_choose.erase(new_weapon_name)
	else:
		var created_money = money_scn.instance()
		created_money.position = chest_position
		call_deferred("add_child", created_money)


func _on_pickup_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true


func _on_pickup_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
