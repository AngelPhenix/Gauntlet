extends TextureButton

var level: int = 0
var max_level: int = 3

func _ready() -> void:
	$Level.text = str(level) + "/" + str(max_level)

func _on_pressed() -> void:
	level = level + 1
	if level > max_level:
		level = max_level
		return
	$Level.text = str(level) + "/" + str(max_level)
	print("Upgrade!")

func _on_focus_entered() -> void:
	print("focused!")
	pass # Replace with function body.
