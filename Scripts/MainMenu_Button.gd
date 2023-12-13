extends Button

onready var menu = get_tree().get_nodes_in_group("menu")[0]
onready var base_position = rect_position.x

func _on_MainMenu_Button_focus_entered():
	if menu.first_focus:
		menu.first_focus = false
	else:
		$AudioStreamPlayer.play()
	$AnimationPlayer.play("ColorChange")
	var tween: Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_position:x", base_position, base_position + 20, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_MainMenu_Button_focus_exited():
	$AnimationPlayer.stop()
	var tween: Tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_position:x", rect_position.x, base_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
