extends NinePatchRect

signal buff_chosen(name)

func _on_NinePatchRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			globals.active_buffs[name].level += 1
			buff_chosen.emit(name)

func _on_NinePatchRect_mouse_entered():
	modulate = Color(1,1,1,1)

func _on_NinePatchRect_mouse_exited():
	modulate = Color(0.7,0.7,0.7,1)
