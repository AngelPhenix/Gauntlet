extends KinematicBody2D

var speed: int = 50
var strength: int = 1
var health: int = 2
var spawner: Object = null
var inventory: Array = []
var label: PackedScene = preload("res://Scenes/Interface/DamageMobLabel.tscn")
onready var player: Object = get_tree().get_nodes_in_group("player")[0]
onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")

func _ready() -> void:
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
			var looted_item = inventory[0].instance()
			get_parent().call_deferred("add_child", looted_item)
			looted_item.global_position = global_position
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

func get_loot() -> void:
	var chance = randi() % 100 + 1
	# 5% chance d'avoir coins
	if chance >= 1 && chance <= 5:
		inventory.append(globals.zombie_possible_items[0])
	
	# Each enemy have a loot table like this : 
	# loot_table = {
	# 	"Ruby": 5,
	#	"Coin": 15,
	#	"Weapon": 0.2
	# }
	# Les clés seront le nom de l'item
	# Les valeurs associées seront le % de drop /100
	# Lorsqu'un "get_loot" sera call, il faudra passer la loot_table
	# Faire une loot table complete ? Faire une loot_table par mob ?
	# get_loot(zombie_loots)
	# A ce moment-là, il faudra faire un foreach de la taille du dictionaire
	# Et roll un random number avec un randomize à chaque fois pour voir si le loot est tombé
	# (random number probablement en float si je veux des 0.5% par exemple
	# Lorsque le loot "tombe", lui donner une position approximative de drop à la position
	# du cadavre du monstre
	# S'assurer que le nom du loot soit bien le nom de sa scène afin de pouvoir
	# rendre le script modulable et ajouter rapidement des items dans les tables de loot
	# Comme par exemple : load("res://Scenes/Interface/+ NOM_DE_LITEM_LOOT +.tscn"
	# Donc "coin" devra être "Coin.tscn" et noté "Coin" dans la table
	# "ruby devra être "Ruby.tscn" et noté "Ruby" dans la table
