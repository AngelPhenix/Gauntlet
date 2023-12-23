extends CanvasLayer

var indexes_left: Array

func _ready():
	randomize()
	for key in globals.buffs:
		indexes_left.append(key)
	
	for buff_panel in $"%BuffContainer".get_children():
		randomize()
		var index = indexes_left[randi() % indexes_left.size()]
		buff_panel.get_tree().get_nodes_in_group("lvlup_sprite")[index].texture = load(globals.buffs[index]["sprite"])
		buff_panel.get_tree().get_nodes_in_group("lvlup_text")[index].text = globals.buffs[index]["tooltip"]
		buff_panel.buff_name = globals.buffs[index]["name"]
		indexes_left.erase(index)
