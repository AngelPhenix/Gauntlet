extends Node2D

const TIME_TO_DISAPPEAR: float = 0.3

func _ready():
	var tween: Tween = create_tween()
	tween.tween_property($Label, "position", position + Vector2(0, -10), TIME_TO_DISAPPEAR).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($Label, "modulate:a", 0, TIME_TO_DISAPPEAR).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
