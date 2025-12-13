extends Button

@onready var menu = get_tree().get_nodes_in_group("menu")[0]
@onready var base_position = position.x

func automatic_selection() -> void :
	if menu.first_focus:
		menu.first_focus = false
	else:
		$AudioStreamPlayer.play()

func _on_MainMenu_Button_focus_entered() -> void: 
	automatic_selection()
	$AnimationPlayer.play("ColorChange")
	
	if self.is_in_group("menu_option_btn") or self.is_in_group("menu_upgrades_btn"):
		return
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", base_position + 20, 0.1)

func _on_MainMenu_Button_focus_exited() -> void:
	$AnimationPlayer.stop()
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", base_position, 0.1)
