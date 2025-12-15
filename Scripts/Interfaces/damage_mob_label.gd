extends Node2D

const TIME_TO_DISAPPEAR_MIN: float = 0.2
const TIME_TO_DISAPPEAR_MAX: float = 0.5
const UPWARD_POSITION_TO_DISAPPEAR_MIN: float = -15
const UPWARD_POSITION_TO_DISAPPEAR_MAX: float = -60

func _ready():
	randomize()
	var tween: Tween = create_tween()
	tween.parallel().tween_property($Label, "position", Vector2(0, randf_range(UPWARD_POSITION_TO_DISAPPEAR_MIN, UPWARD_POSITION_TO_DISAPPEAR_MAX)), randf_range(TIME_TO_DISAPPEAR_MIN, TIME_TO_DISAPPEAR_MAX))
	tween.parallel().tween_property($Label, "modulate:a", 0, 0.8)
	await tween.finished
	queue_free()
