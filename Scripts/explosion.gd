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

# Explo1 : Radius increase
# Explo2 : Damage increase
func apply_upgrades() -> void:
	scale = Vector2(globals.get_current_upgrade_effect("Explo1"),globals.get_current_upgrade_effect("Explo1"))
	# dmg = base_damage of 3 + [1/3/7/10/20/40].Explo2level + 1*number of active explosive buff
	damage = base_damage * globals.get_current_upgrade_effect("Explo2") + globals.get_active_buff_level("explosive")
