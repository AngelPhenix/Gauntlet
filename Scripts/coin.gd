extends Area2D

var value: int = 1

func _on_Coin_body_entered(body: Object) -> void:
	if body.is_in_group("player"):
		body.add_coins(value)
		var tween: Tween = create_tween()
		tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 1)
		tween.parallel().tween_property(self, "position", position + Vector2(500, -500), 1)
		await tween.finished
		queue_free()
