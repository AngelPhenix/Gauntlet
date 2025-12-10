extends Control

@onready var player: Node = get_tree().get_nodes_in_group("player")[0]
@onready var fadeout_scn: PackedScene = preload("res://Scenes/Interface/Fadeout.tscn")

func _on_menu_pressed() -> void:
	var fadeout: Node = fadeout_scn.instantiate()
	add_child(fadeout)
	await fadeout.fadeout()
	globals.get_node("ingame_music").stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Stages/MainMenu.tscn")
