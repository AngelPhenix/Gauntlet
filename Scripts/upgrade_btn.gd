extends TextureButton

func _ready() -> void:
	$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)

func _on_pressed() -> void:
	#price = globals.upgrades["explo1"].price[level]
	globals.upgrades[name].level = globals.upgrades[name].level + 1
	if globals.upgrades[name].level > globals.upgrades[name].max_level:
		globals.upgrades[name].level = globals.upgrades[name].max_level
		return
	$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)

func _on_focus_entered() -> void:
	pass # Replace with function body.
