extends Area2D

var value: int = 20
var can_pickup = false

var player

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && can_pickup:
		player.add_coins(value)
		queue_free()

func _on_Money_body_entered(body):
	if body.is_in_group("player"):
		can_pickup = true
		player = body

func _on_Money_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false
		player = body
