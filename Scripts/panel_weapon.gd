extends Control

var weapon_name_chosen
signal game_can_start
@onready var main_level : Node = get_tree().get_nodes_in_group("level")[0]
@onready var player : Node = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	position = Vector2(-1500,0)
	$VBoxContainer/Label.text = weapon_name_chosen
	connect("game_can_start", Callable(main_level, "game_start"))
	$VBoxContainer/Label2.text = "ATK : " + str(globals.weapons[weapon_name_chosen]["attack"])

func _on_PanelWeaponChoosing_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if weapon_name_chosen and len(globals.weapons) > 0:
				player.weapon_picked_up(weapon_name_chosen)
				globals.weapons_left_to_choose.erase(weapon_name_chosen)
				emit_signal("game_can_start")
				get_parent().queue_free()

func _on_PanelWeaponChoosing_mouse_entered():
	$ColorRect.color.a = 0

func _on_PanelWeaponChoosing_mouse_exited():
	$ColorRect.color.a = 0.39
