extends Control

# Check les armes du joueur s'il en a 
# S'il en a, prendre chaque arme pour les afficher dans la hotbar
# Check si le joueur a l'index de l'arme selectionnée (Store in globals.last_weapon_index)

export var debug_mode: bool = false

onready var player: Node = get_tree().get_nodes_in_group("player")[0]
onready var inventory: Node = get_tree().get_nodes_in_group("inventory")[0]
var rect_gun_scn = preload("res://Scenes/Interface/GunNode.tscn")
var weapons: Array = []
var exp_total: int = 0

func _ready() -> void:
	player.connect("coin_pickedup", self, "_on_coin_pickedup")
	player.connect("hurt", self, "_on_player_hurt")
	player.connect("exp_pickedup", self, "_on_player_add_experience")
	_update_hud()

func _update_hud() -> void:
	$CoinCounter/number.text = str(globals.total_coins_collected)
	$Health_Bar/hp.max_value = player.max_health
	$Health_Bar/hp.value = player.health
	$Exp_Bar.value = player.experience
	exp_total = player.experience
	
	if globals.player_weapons_in_inventory.size() > 0:
		for weapon in globals.player_weapons_in_inventory:
			_on_Interface_weapon_pickedup(weapon)
	
	# Gives every weapon in the HUD a lower alpha and the equipped one with the higher alpha 
	if globals.level > 1:
		var equipped_weapon_index = globals.player_weapons_in_inventory.find(globals.player_equipped_weapon, 0)
		for weapon in inventory.get_children():
			weapon.modulate.a = 0.3
		inventory.get_children()[equipped_weapon_index].modulate.a = 1

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

func delete_node(node: Node) -> void:
	inventory.remove_child(node)
	node.queue_free()

func _on_coin_pickedup(total_coins: int) -> void:
	$CoinCounter/number.text = str(total_coins)

func _on_player_hurt(new_health: int) -> void:
	$Health_Bar/hp.value = new_health
	
func _on_player_add_experience(experience: int) -> void:
	var new_exp_value = exp_total + experience
	if new_exp_value < $Exp_Bar.max_value:
		exp_total += experience
		$Exp_Bar.value = exp_total
	else:
		player.levelup()
		exp_total = new_exp_value - $Exp_Bar.max_value
		$Exp_Bar.value = exp_total

func _on_Interface_weapon_pickedup(weapon_name_picked_up: String) -> void:
	var new_node = rect_gun_scn.instance()
	new_node.texture = load(globals.weapons[weapon_name_picked_up]["png_path"])
	inventory.add_child(new_node)
	if player.weapons_in_inventory.size() > 1:
		new_node.modulate.a = 0.3
