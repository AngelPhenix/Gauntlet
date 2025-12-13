extends CharacterBody2D

@export var damage_label: PackedScene
@onready var player: Object = get_tree().get_nodes_in_group("player")[0]
@onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")
@onready var burning_particle: PackedScene = preload("res://Scenes/Particles/BurningParticle.tscn")

var level: int = 1
var speed: int = 20
var strength: int = 1
var health: int = 35
var veteran: bool = false
var boss: bool = false
var drop_table: Array = [globals.coin_scn, globals.exp_scn]
var inventory: Array = []

# Debuff Related Variables
var burning: bool = false


func _ready() -> void:
	# Fill enemy inventory
	get_loot()
	
	if veteran:
		become_veteran()
	if boss:
		become_boss()

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
	speed = speed / 5
	strength = strength * 3

func become_boss() -> void:
	level = 3
	$sprite.scale = Vector2(3,3)
	$colshape.shape.radius = 24
	health = health * 20
	speed = speed / 8
	strength = strength * 10

func hit(damage: int) -> void:
	globals.get_node("zombie_hit").play()
	health -= damage
	display_damage(damage)
	
	if health <= 0:
		_drop_items()
		queue_free()
		var blood = blood_particle.instantiate()
		blood.position = global_position
		get_parent().add_child(blood)

func _drop_items() -> void:
	if inventory.size() > 0:
		for item in inventory:
			var looted_item = item.instantiate()
			if looted_item.is_in_group("experience"):
				looted_item._change_exp_level(level)
			get_parent().call_deferred("add_child", looted_item)
			looted_item.global_position = global_position + Vector2(5, 5)

func display_damage(damage: int) -> void:
	var dmg_taken = damage_label.instantiate()
	dmg_taken.position = position + Vector2(-8, -10)
	get_tree().get_root().add_child(dmg_taken)
	dmg_taken.get_node("Label").text = str(damage)

func get_loot() -> void:
	var chance = randi() % 100 + 1
	# Chance d'avoir un coin : 5%
	if chance >= 0 && chance <= 5:
		inventory.append(drop_table[0])
	# Chance d'avoir exp : 20%
	if chance > 5 && chance <= 25:
		inventory.append(drop_table[1])


# ########################### ON FIRE STATUS ########################### #
func on_fire() -> void:
	burning = true
	$FireDuration.wait_time = globals.base_burn_timer
	$FireTick.wait_time = globals.base_tick_burn
	$FireDuration.start()
	$FireTick.start()
	self.modulate = Color(1,0.5,0)
	if burning:
		var burning_effect = burning_particle.instantiate()
		add_child(burning_effect)
		var tween: Tween = create_tween()
		tween.tween_property(self, "modulate", Color(1,1,1), globals.base_burn_timer)

func _on_OnFire_timeout():
	hit(globals.active_buffs["fire"].level)

func _on_StopFire_timeout():
	$FireTick.stop()
	burning = false
