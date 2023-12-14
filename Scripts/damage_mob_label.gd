extends Node2D

const TIME_TO_DISAPPEAR: float = 0.3

func _ready():
	$Label/tween.interpolate_property(self, "position", position, position + Vector2(0,-10), TIME_TO_DISAPPEAR, Tween.TRANS_BACK, Tween.EASE_IN)
	$Label/tween.interpolate_property(self, "modulate:a", 1, 0, TIME_TO_DISAPPEAR, Tween.TRANS_BACK, Tween.EASE_IN)
	$Label/tween.start()

func _on_tween_tween_completed(object, key):
	queue_free()
