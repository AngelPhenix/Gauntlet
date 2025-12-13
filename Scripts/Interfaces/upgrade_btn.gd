extends TextureButton

# Connected on scene/script MainMenu to update the total amount of money left after spending it
signal coins_spent(value)
# Connected on scene/script SkillDescriptionContent to update price when skill leveled-up
signal skill_levelup(new_skill_price)

var locked: bool

@onready var skill_desc_node: Node = get_tree().get_nodes_in_group("skill_desc_node")[0]
@onready var skill_description: Node = get_tree().get_nodes_in_group("skill_desc")[0]
@onready var skill_price: Node = get_tree().get_nodes_in_group("skill_price")[0]

func _ready() -> void:
	$Level.text = str(globals.upgrades[name].level) + "/" + str(globals.upgrades[name].max_level)
	
	if globals.upgrades[name].locked:
		self.texture_focused = load("res://Sprites/Buffs/disabled_focus.png")

func _on_pressed() -> void:
	if globals.upgrades[name].level < globals.upgrades[name].max_level:
		 # Player has enough money compared to what the skill level costs
		if globals.current_coins >= globals.upgrades[name].price[globals.upgrades[name].level]:
			
			# Spend the right amount of money to upgrade then update money display
			globals.current_coins -= globals.get_upgrade_price(name)
			globals.get_node("skill_lvlup").play()
			coins_spent.emit()
			
			# Level up the skill. If it's higher than max_level, lock it
			globals.upgrades[name].level = globals.upgrades[name].level + 1
			
			# Unlocks the related nodes that needs this one to be minimum lvl 1
			for node in get_tree().get_nodes_in_group("btn_upgrade"):
				if node.name == globals.upgrades[name].next_upgrade:
					globals.upgrades[node.name].locked = false
					node.disabled = false
					node.texture_focused = load("res://Sprites/Buffs/"+node.name+"_focused.png")
			
			if globals.upgrades[name].level > globals.upgrades[name].max_level:
				globals.upgrades[name].level = globals.upgrades[name].max_level
				return
			
			if !globals.upgrades[name].level == globals.upgrades[name].max_level:
				skill_levelup.emit(globals.get_upgrade_price(name))
			else:
				skill_levelup.emit("xx")
			
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
		skill_price.text = "xx"
	skill_desc_node.visible = true

func _on_focus_exited() -> void:
	skill_desc_node.visible = false
