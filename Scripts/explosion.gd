extends Area2D

var damage: int = 3

func _ready():
	await get_tree().physics_frame

	for body in get_overlapping_bodies():
		print(body)
		if body.is_in_group("enemy") and body.has_method("hit"):
			body.hit(damage)

	# Optional: play animation
	$AnimationPlayer.play("detonate")
	await $AnimationPlayer.animation_finished
	queue_free()
