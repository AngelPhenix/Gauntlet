extends Area2D

var can_pickup: bool = false
onready var interface: Node = get_tree().get_nodes_in_group("interface")[0]
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

var weapon_name: String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && can_pickup:
		player.weapon_picked_up(weapon_name)
		queue_free()

func _on_Gun_body_entered(body):
	if body.is_in_group("player"):
		can_pickup = true

func _on_Gun_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false
