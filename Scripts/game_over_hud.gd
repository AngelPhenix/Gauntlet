extends Control

const FADE_OUT_TIME: float = 1.0

func _on_menu_pressed() -> void:
	await fade_menu()
	globals.get_node("menu_music").stop()
	get_tree().change_scene_to_file("res://Stages/MainMenu.tscn")

func fade_menu():
	var tween: Tween = create_tween()
	tween.tween_property($Fadeout, "modulate:a", 1, FADE_OUT_TIME).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
