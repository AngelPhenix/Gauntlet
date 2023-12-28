extends Area2D

func _on_Bonus_body_entered(body: Object) -> void:
	if body.is_in_group("player"):
		body.add_coins(50)
		$opening.play()
		queue_free()
