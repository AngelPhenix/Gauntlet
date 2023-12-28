extends Area2D

var damage: int = 3

func _on_Explosion_body_entered(body):
	if body.is_in_group("enemy"):
		if body.has_method("hit"):
			$AnimationPlayer.play("detonate")
			body.hit(damage)
			yield($AnimationPlayer, "animation_finished")
			queue_free()
