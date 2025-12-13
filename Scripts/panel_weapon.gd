extends Control

var weapon_name_chosen
@onready var main_level : Node = get_tree().get_nodes_in_group("level")[0]
@onready var player : Node = get_tree().get_nodes_in_group("player")[0]
@onready var weapon_choose_hud_scn: Node = get_tree().get_nodes_in_group("choose_weapon_hud")[0]

func _ready() -> void:
	position = Vector2(-500,0)
	%WeaponName.text = weapon_name_chosen
	%WeaponATK.text = "ATK : " + str(globals.weapons[weapon_name_chosen].attack)

func _on_PanelWeaponChoosing_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if weapon_name_chosen and len(globals.weapons) > 0:
				player.weapon_picked_up(weapon_name_chosen)
				get_tree().paused = false
				weapon_choose_hud_scn.queue_free()

func _on_PanelWeaponChoosing_mouse_entered():
	$ColorRect.color.a = 0

func _on_PanelWeaponChoosing_mouse_exited():
	$ColorRect.color.a = 0.50
