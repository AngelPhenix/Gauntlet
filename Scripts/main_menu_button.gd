extends Button

@onready var menu = get_tree().get_nodes_in_group("menu")[0]
@onready var base_position = position.x

func _on_MainMenu_Button_focus_entered():
	if menu.first_focus:
		menu.first_focus = false
	else:
		$AudioStreamPlayer.play()
	$AnimationPlayer.play("ColorChange")
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", base_position + 20, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _on_MainMenu_Button_focus_exited():
	$AnimationPlayer.stop()
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", base_position - 20, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
