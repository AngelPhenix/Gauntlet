extends TileMap

onready var level = get_tree().get_nodes_in_group("level")[0]

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if globals.center_touched:
			level.generate_new_fragments(position)
		else:
			globals.center_touched = true
		$Area2D.set_deferred("monitoring", false)
		level.player_frag = self

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		$Area2D.set_deferred("monitoring", true)
