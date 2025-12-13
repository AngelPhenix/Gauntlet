extends CanvasLayer

var indexes_left: Array
var index: int = 0

func _ready():
	for key in globals.active_buffs:
		indexes_left.append(key)
	
	for buff_panel in %BuffContainer.get_children():
		randomize()
		var buff_name = indexes_left[randi() % indexes_left.size()]
		print(buff_name)
		buff_panel.get_tree().get_nodes_in_group("lvlup_sprite")[index].texture = load(globals.active_buffs[buff_name].sprite)
		buff_panel.get_tree().get_nodes_in_group("lvlup_text")[index].text = globals.active_buffs[buff_name].description
		buff_panel.buff_name = buff_name
		indexes_left.erase(buff_name)
		index += 1
