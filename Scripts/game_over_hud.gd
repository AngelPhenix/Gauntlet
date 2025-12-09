extends Control

const FADE_OUT_TIME: float = 0.5

@onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	player.dead.connect(_on_player_dead)

func _on_menu_pressed() -> void:
	await _fade_menu()
	globals.get_node("ingame_music").stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Stages/MainMenu.tscn")

func _on_player_dead() -> void:
	get_tree().paused = true

func _fade_menu():
	var tween: Tween = create_tween()
	tween.tween_property($Fadeout, "modulate:a", 1, FADE_OUT_TIME)
	await tween.finished
