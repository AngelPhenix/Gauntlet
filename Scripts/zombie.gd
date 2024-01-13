extends KinematicBody2D

var speed: int = 10
var strength: int = 1
var health: int = 35
var inventory: Array = []
var label: PackedScene = preload("res://Scenes/Interface/DamageMobLabel.tscn")
var burning: bool = false
var burning_timer: int = 2
var veteran: bool = false
var boss: bool = false
var level: int = 1
var drop_table: Array = [globals.coin_scn, globals.exp_scn, globals.bonus_scn]

onready var player: Object = get_tree().get_nodes_in_group("player")[0]
onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")

func _ready() -> void:
	$StopFire.wait_time = burning_timer
	get_loot()
	if veteran:
		become_veteran()

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	$sprite.rotation = direction.angle()
	$colshape.rotation = direction.angle()
	move_and_collide(direction * delta * speed)

func become_veteran() -> void:
	level = 2
	$sprite.scale = Vector2(2,2)
	$colshape.shape.radius = 16
	health = health * 5
	speed = speed / 3
	strength = strength * 3

func become_boss() -> void:
	level = 3
	$sprite.scale = Vector2(3,3)
	$colshape.shape.radius = 24
	health = health * 15
	speed = speed / 5
	strength = strength * 10

func hit(damage: int) -> void:
	globals.get_node("zombie_hit").play()
	health -= damage
	display_damage(damage)
	$tween.interpolate_property(self, "modulate", Color(1,0,0), Color(1,1,1), 0.05, Tween.TRANS_QUINT, Tween.EASE_IN)
	$tween.start()
	if health <= 0:
		_drop_items()
		queue_free()
		var blood = blood_particle.instance()
		blood.position = global_position
		get_parent().add_child(blood)

func _drop_items() -> void:
	if inventory.size() > 0:
		for item in inventory:
			var looted_item = item.instance()
			if looted_item.is_in_group("experience"):
				looted_item._change_exp_level(level)
			get_parent().call_deferred("add_child", looted_item)
			looted_item.global_position = global_position + Vector2(5, 5)

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
	# 5% chance d'avoir bonus
	if chance >= 1 && chance <= 2:
		inventory.append(drop_table[2])
	# Chance d'avoir un coin
	if chance > 2 && chance <= 6:
		inventory.append(drop_table[0])
	# Chance d'avoir exp
	if chance > 6 && chance <= 56:
		inventory.append(drop_table[1])

func _on_OnFire_timeout():
	hit(player.buffs["fire"])

func _on_StopFire_timeout():
	$OnFire.stop()
	burning = false
