extends Control

export var debug_mode: bool = false

onready var player: Node = get_tree().get_nodes_in_group("player")[0]
onready var inventory: Node = get_tree().get_nodes_in_group("inventory")[0]
var rect_gun_scn = preload("res://Scenes/Interface/GunNode.tscn")
var weapons: Array = []
var exp_total: int = 0
var exp_required: int

func _ready() -> void:
	player.connect("coin_pickedup", self, "_on_coin_pickedup")
	player.connect("hurt", self, "_on_player_hurt")
	player.connect("exp_pickedup", self, "_on_player_add_experience")
	exp_required = get_required_experience(player.level + 1)
	_update_hud()

func _update_hud() -> void:
	$CoinCounter/number.text = str(globals.total_coins_collected)
	$hp.max_value = player.max_health
	$hp.value = player.health
	$Exp_Bar.max_value = exp_required
	$Exp_Bar.value = player.experience
	
	if globals.player_weapons_in_inventory.size() > 0:
		for weapon in globals.player_weapons_in_inventory:
			_on_Interface_weapon_pickedup(weapon)

func equipped_weapon_swapped(index_change: int) -> void:
	var index_of_equipped_weapon: int = player.weapons_in_inventory.find(player.equipped_weapon, 0)
	var new_index: int = index_of_equipped_weapon + index_change
	if new_index < 0:
		new_index = 0
	elif new_index > player.weapons_in_inventory.size() - 1 :
		new_index  = player.weapons_in_inventory.size() - 1 
	inventory.get_children()[index_of_equipped_weapon].modulate.a = 0.3
	inventory.get_children()[new_index].modulate.a = 1
	player.weapon_swapped(player.weapons_in_inventory[new_index])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				equipped_weapon_swapped(-1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				equipped_weapon_swapped(1)
	if event.is_action_pressed("lvlup") && debug_mode:
		player.levelup()
		$Level.text = "Lv." + str(player.level)

func delete_node(node: Node) -> void:
	inventory.remove_child(node)
	node.queue_free()

func _on_coin_pickedup(total_coins: int) -> void:
	$CoinCounter/number.text = str(total_coins)

func _on_player_hurt(new_health: int) -> void:
	$hp.value = new_health
	
	
func get_required_experience(level: int) -> float:
	return round(pow(level, 1.8) + level * 4)
	
func _on_player_add_experience(exp_gained: int) -> void:
	if player.experience + exp_gained < exp_required:
		player.experience += exp_gained
		$Exp_Bar.value = player.experience
	else:
		player.levelup()
		player.experience = player.experience - exp_required
		$Level.text = "Lv." + str(player.level)
		$Exp_Bar.value = player.experience
		exp_required = get_required_experience(player.level + 1)
		$Exp_Bar.max_value = exp_required
	

func _on_Interface_weapon_pickedup(weapon_name_picked_up: String) -> void:
	var new_node = rect_gun_scn.instance()
	new_node.texture = load(globals.weapons[weapon_name_picked_up]["png_path"])
	inventory.add_child(new_node)
	if player.weapons_in_inventory.size() > 1:
		new_node.modulate.a = 0.3
