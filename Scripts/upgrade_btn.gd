extends TextureButton

# Connected on scene/script MainMenu to update the total amount of money left after spending it
signal coins_spent(value)
# Connected on scene/script SkillDescriptionContent to update price when skill leveled-up
signal skill_levelup(new_skill_price)

var locked: bool = true

@onready var skill_desc_node: Node = get_tree().get_nodes_in_group("skill_desc_node")[0]
@onready var skill_description: Node = get_tree().get_nodes_in_group("skill_desc")[0]
@onready var skill_price: Node = get_tree().get_nodes_in_group("skill_price")[0]

func _ready() -> void:
	$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)

func _on_pressed() -> void:
	if globals.upgrades[name].level < globals.upgrades[name].max_level:
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
			
			if !globals.upgrades[name].level == globals.upgrades[name].max_level:
				emit_signal("skill_levelup", globals.upgrades[name].price[globals.upgrades[name].level])
			else:
				emit_signal("skill_levelup", "00")
			
			# Update the display to show current level after leveling it up
			$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)
			
		 # Player doesn't have enough money to upgrade the buff
		else:
			return

func _on_focus_entered() -> void:
	skill_description.text = globals.upgrades[name].description
	if !globals.upgrades[name].level == globals.upgrades[name].max_level:
		skill_price.text = str(globals.upgrades[name].price[globals.upgrades[name].level])
	else:
		skill_price.text = "00"
	skill_desc_node.visible = true

func _on_focus_exited() -> void:
	skill_desc_node.visible = false
