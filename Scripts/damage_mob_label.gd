extends Node2D

const TIME_TO_DISAPPEAR: float = 0.3

func _ready():
	var tween: Tween = create_tween()
	tween.parallel().tween_property($Label, "position", Vector2(0, -10), TIME_TO_DISAPPEAR)
	tween.parallel().tween_property($Label, "modulate:a", 0, TIME_TO_DISAPPEAR)
