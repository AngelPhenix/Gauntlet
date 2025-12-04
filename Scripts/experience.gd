extends Area2D

var value: int = 1

func _on_Experience_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		body.add_experience(value)
		queue_free()

func _change_exp_level(mob_level: int) -> void:
	if mob_level == 1:
		$Sprite2D.frame = 0
		value = 1
	if mob_level == 2:
		$Sprite2D.frame = 1
		value = 3
	if mob_level == 3:
		$Sprite2D.frame = 2
		value = 6
