extends CanvasLayer

var indexes_left: Array
var index: int = 0

func _ready():
	var buff_sprites: Array = get_tree().get_nodes_in_group("buff_sprite")
	var buff_names: Array = get_tree().get_nodes_in_group("buff_name")
	
	for key in globals.active_buffs:
		indexes_left.append(key)
	
	for buff_card in %BuffContainer.get_children():
		var buff_name = indexes_left[randi() % indexes_left.size()]

		buff_sprites[index].texture = load(globals.active_buffs[buff_name].sprite)
		buff_names[index].text = globals.active_buffs[buff_name].description
		buff_card.name = buff_name
		buff_card.buff_chosen.connect(_on_buff_chosen)
		
		indexes_left.erase(buff_name)
		index += 1

func _on_buff_chosen(buff_name: String) -> void:
	get_tree().paused = false
	globals.get_node("levelup_music").stop()
	globals.reset_music_volume("ingame_music")
	queue_free()
