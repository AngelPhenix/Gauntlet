extends Control

@export var fadeout_scn: PackedScene

func _on_menu_pressed() -> void:
	await fade_menu()
	globals.get_node("ingame_music").stop()
	get_tree().paused = false
	globals.reset_active_buffs()
	get_tree().change_scene_to_file("res://Stages/MainMenu.tscn")

func fade_menu() -> void:
	var fadeout: Node = fadeout_scn.instantiate()
	add_child(fadeout)
	await fadeout.fadeout()
