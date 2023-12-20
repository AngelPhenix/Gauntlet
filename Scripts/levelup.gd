extends CanvasLayer

func _ready():
	var index: int = 0
	for buff_panel in $"%BuffContainer".get_children():
		buff_panel.get_tree().get_nodes_in_group("lvlup_sprite")[index].texture = load(globals.buffs[index]["sprite"])
		buff_panel.get_tree().get_nodes_in_group("lvlup_text")[index].text = globals.buffs[index]["tooltip"]
		index += 1
