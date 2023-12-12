extends Area2D

var can_pickup: bool = false
onready var interface: Node = get_tree().get_nodes_in_group("interface")[0]
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

var weapon_name: String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && can_pickup:
		# If the player has 5 weapons_in_inventory already : delete the one selected
		if player.weapons_in_inventory.size() > 4:
			player.weapons_in_inventory.erase(player.equipped_weapon)
			player.weapons_in_inventory.remove(player.index)
			var node_to_delete: Node = interface.get_node("weapons_in_inventory/Container").get_child(interface.index)
			interface.delete_node(node_to_delete)
		player.weapon_picked_up(weapon_name)
		queue_free()

func _on_Gun_body_entered(body):
	if body.is_in_group("player"):
		can_pickup = true

func _on_Gun_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false
