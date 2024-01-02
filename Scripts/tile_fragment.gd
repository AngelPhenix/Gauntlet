extends TileMap

onready var level = get_tree().get_nodes_in_group("level")[0]

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if globals.center_touched:
			level.generate_new_fragments(position)
			$Area2D.queue_free()
		else:
			globals.center_touched = true
			level.player_frag = self
			$Area2D.queue_free()

