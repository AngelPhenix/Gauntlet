extends TextureButton

signal coins_spent(value)
signal skill_levelup(new_skill_price)

@onready var skill_desc_node: Node = get_tree().get_nodes_in_group("skill_desc_node")[0]
@onready var skill_description: Node = get_tree().get_nodes_in_group("skill_desc")[0]
@onready var skill_price: Node = get_tree().get_nodes_in_group("skill_price")[0]

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
		
		emit_signal("skill_levelup", globals.upgrades[name].price[globals.upgrades[name].level])
		# Update the display to show current level after leveling it up
		$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)
		
	 # Player doesn't have enough money to upgrade the buff
	else:
		return

func _on_focus_entered() -> void:
	print(globals.upgrades[name].description)
	skill_description.text = globals.upgrades[name].description
	skill_price.text = str(globals.upgrades[name].price[globals.upgrades[name].level])
	skill_desc_node.visible = true

func _on_focus_exited() -> void:
	skill_desc_node.visible = false
