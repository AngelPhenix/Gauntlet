extends KinematicBody2D

var speed: int = 10
var strength: int = 1
var health: int = 10
var spawner: Object = null
var inventory: Array = []
var label: PackedScene = preload("res://Scenes/Interface/DamageMobLabel.tscn")
var burning: bool = false
var burning_timer: int = 2

onready var player: Object = get_tree().get_nodes_in_group("player")[0]
onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")

func _ready() -> void:
	$StopFire.wait_time = burning_timer
	get_loot()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	$sprite.rotation = direction.angle()
	$shape.rotation = direction.angle()
	move_and_collide(direction * delta * speed)

func hit(damage: int) -> void:
	globals.get_node("zombie_hit").play()
	health -= damage
	display_damage(damage)
	$tween.interpolate_property(self, "modulate", Color(1,0,0), Color(1,1,1), 0.05, Tween.TRANS_QUINT, Tween.EASE_IN)
	$tween.start()
	if health <= 0:
		if inventory.size() > 0:
			for item in inventory:
				var looted_item = item.instance()
				get_parent().call_deferred("add_child", looted_item)
				looted_item.global_position = global_position + Vector2(5, 5)
		queue_free()
		var blood = blood_particle.instance()
		blood.position = global_position
		get_parent().add_child(blood)
		if spawner != null:
			spawner.delete_object(self)

func display_damage(damage: int) -> void:
	var dmg_taken = label.instance()
	dmg_taken.position = global_position + Vector2(0,-10)
	get_tree().get_root().add_child(dmg_taken)
	dmg_taken.get_node("Label").text = str(damage)

func on_fire() -> void:
	$OnFire.start()
	$StopFire.start()
	burning = true
	if burning:
		$Particles2D.emitting = true
		$tween.interpolate_property(self, "modulate", Color(1,0.5,0), Color(1,1,1), burning_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
		$tween.start()
	
	
func get_loot() -> void:
	var chance = randi() % 100 + 1
	# 5% chance d'avoir coins
	if chance >= 1 && chance <= 5:
		inventory.append(globals.zombie_possible_items[0])
	if chance > 5 && chance <= 40:
		inventory.append(globals.zombie_possible_items[1])

func _on_OnFire_timeout():
	hit(2)

func _on_StopFire_timeout():
	$OnFire.stop()
	burning = false
