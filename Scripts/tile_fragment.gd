extends TileMap

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("Entered!")
		$Area2D.queue_free()
