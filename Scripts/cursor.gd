extends Sprite

var positions: Array = []
var index: int = 0

func _ready() -> void:
	for node in $"%Labels".get_children():
		if node is Label and node.visible:
			positions.append(node)
			node.modulate.a = 0.3
	set_selection(index)

func set_selection(new_index: int) -> void:
	if new_index >= 0 && new_index < len(positions):
		for option in positions:
			option.modulate.a = 0.3
		index = new_index
		var selected_node: Label = positions[index]
		position = Vector2(selected_node.rect_position.x - texture.get_width()/2 - 5, selected_node.rect_position.y + selected_node.rect_size.y/2)
		selected_node.modulate.a = 1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		set_selection(index - 1)
	if Input.is_action_just_pressed("ui_down"):
		set_selection(index + 1)
	if Input.is_action_just_pressed("ui_select"):
		var selected_position: Label = positions[index]
		if selected_position.has_method("callback"):
			selected_position.callback()
