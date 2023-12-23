extends NinePatchRect

var buff_name: String

onready var player : Node = get_tree().get_nodes_in_group("player")[0]
onready var lvlup_screen: Node = get_tree().get_nodes_in_group("lvlup_screen")[0]

func _on_NinePatchRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			player.buff_collected(buff_name)
			get_tree().paused = false
			lvlup_screen.queue_free()


func _on_NinePatchRect_mouse_entered():
	modulate = Color(1,1,1,1)


func _on_NinePatchRect_mouse_exited():
	modulate = Color(0.7,0.7,0.7,1)
