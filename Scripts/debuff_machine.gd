extends Node2D

func burn_entity(entity: Node, burning_timer: int) -> void:
	$Existing.wait_time = burning_timer
	$BurningEffect.emitting = true
	$BurningEffect.lifetime = burning_timer
	$Existing.start()

func _on_existing_timeout() -> void:
	queue_free()
