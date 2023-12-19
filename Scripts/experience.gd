extends Area2D

var value: int = 10

func _on_Experience_body_entered(body):
	if body.is_in_group("player"):
		body.add_experience(value)
		queue_free()
