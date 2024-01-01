extends TileMap

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if !globals.game_just_started:
			print("Do the thing here")
			$Area2D.queue_free()
		else:
			globals.game_just_started = false
			$Area2D.queue_free()
