extends Area2D

var base_damage: int = 3
var damage: int
var radius: int

func _ready():
	apply_upgrades()
	await get_tree().physics_frame

	for body in get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("hit"):
			body.hit(damage)

	# Optional: play animation
	$AnimationPlayer.play("detonate")
	await $AnimationPlayer.animation_finished
	queue_free()

func apply_upgrades() -> void:
	scale = Vector2(globals.upgrades["Explo1"].effect[globals.upgrades["Explo1"].level],globals.upgrades["Explo1"].effect[globals.upgrades["Explo1"].level])
	damage = base_damage * globals.upgrades["Explo2"].effect[globals.upgrades["Explo2"].level]
