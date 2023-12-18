extends Area2D

func _ready():
	globals.connect("end_level", self, "activate_teleporter")

func activate_teleporter() -> void:
	$Sprite.frame = 1
	$CollisionShape2D.set_deferred("disabled", false)
	$Particles2D.emitting = true

func _on_Teleporter_body_entered(body):
	if body.is_in_group("player"):
		globals.level = globals.level + 1
		globals.player_weapons_in_inventory = body.weapons_in_inventory
		globals.player_equipped_weapon = body.equipped_weapon
		globals.hud = get_tree().get_nodes_in_group("inventory")
		get_tree().change_scene("res://Stages/FinishedStages/Level_" + str(globals.level) + ".tscn")
