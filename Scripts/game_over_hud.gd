extends Control

@onready var fadeout_scn: PackedScene = preload("res://Scenes/Interface/Fadeout.tscn")

func _on_menu_pressed() -> void:
	await fade_menu()
	globals.get_node("ingame_music").stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Stages/MainMenu.tscn")

func fade_menu() -> void:
	var fadeout: Node = fadeout_scn.instantiate()
	add_child(fadeout)
	await fadeout.fadeout()
