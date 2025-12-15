extends Control

var weapon_name: String

signal weapon_chosen(weapon_name)

func _ready() -> void:
	position = Vector2(-1500,0)
	%WeaponName.text = weapon_name
	%WeaponATK.text = "ATK : " + str(globals.weapons[weapon_name].attack)
	%WeaponSprite.texture = load(globals.weapons[weapon_name].png_path)

func _on_PanelWeaponChoosing_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if weapon_name and len(globals.weapons) > 0:
				weapon_chosen.emit(weapon_name)

func _on_PanelWeaponChoosing_mouse_entered():
	$ColorRect.color.a = 0

func _on_PanelWeaponChoosing_mouse_exited():
	$ColorRect.color.a = 0.50
