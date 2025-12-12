extends CanvasLayer

var indexes_left: Array
var index: int = 0

func _ready():
	for key in globals.buffs:
		indexes_left.append(key)
	
	for buff_panel in %BuffContainer.get_children():
		randomize()
		var buff_key = indexes_left[randi() % indexes_left.size()]
		buff_panel.get_tree().get_nodes_in_group("lvlup_sprite")[index].texture = load(globals.buffs[buff_key]["sprite"])
		buff_panel.get_tree().get_nodes_in_group("lvlup_text")[index].text = globals.buffs[buff_key]["tooltip"]
		buff_panel.buff_name = globals.buffs[buff_key]["name"]
		indexes_left.erase(buff_key)
		index += 1
