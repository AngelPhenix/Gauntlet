extends TextureButton

signal coins_spent(value)

func _ready() -> void:
	$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)

func _on_pressed() -> void:
	 # Player has enough money compared to what the skill level costs
	if globals.total_coins_collected >= globals.upgrades[name].price[globals.upgrades[name].level]:
		
		# Spend the right amount of money to upgrade then update money display
		globals.total_coins_collected -= globals.upgrades[name].price[globals.upgrades[name].level]
		emit_signal("coins_spent")
		
		# Level up the skill. If it's higher than max_level, lock it
		globals.upgrades[name].level = globals.upgrades[name].level + 1
		if globals.upgrades[name].level > globals.upgrades[name].max_level:
			globals.upgrades[name].level = globals.upgrades[name].max_level
			return
		
		# Update the display to show current level after leveling it up
		$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)
		
	 # Player doesn't have enough money to upgrade the buff
	else:
		return

func _on_focus_entered() -> void:
	pass # Replace with function body.

func upgrade_buff() -> void:
	emit_signal("coins_spent", )
	pass
