extends ColorRect

const FADE_OUT_TIME: float = 0.5

func fadeout(time: float = FADE_OUT_TIME) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, time)
	await tween.finished
