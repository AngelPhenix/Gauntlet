extends Node2D

const TIME_TO_DISAPPEAR: float = 0.3

#FIX THE POSITION OF THE LABEL GOING TOP-RIGHT FOR SOME REASON????

func _ready():
	var tween: Tween = create_tween()
	tween.parallel().tween_property($Label, "position", Vector2(0, -20), TIME_TO_DISAPPEAR)
	tween.parallel().tween_property($Label, "modulate:a", 0, TIME_TO_DISAPPEAR)
