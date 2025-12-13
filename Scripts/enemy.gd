extends CharacterBody2D

class_name enemy

var speed: int
var strength: int
var health: int
var burning: bool = false
var burning_timer: int = 2


var level: int = 1
var veteran: bool = false
var boss: bool = false

var inventory: Array
var drop_table: Array = [globals.coin_scn, globals.exp_scn]
var label: PackedScene = preload("res://Scenes/Interfaces/DamageMobLabel.tscn")

@onready var player: Object = get_tree().get_nodes_in_group("player")[0]
@onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")

func mob_setup() -> void:
	# On change d'abord ses stats en fonction de son level.
	# Puisque chaque enemy aura des stats différentes, comment on se débrouille ?
	# Est-ce qu'on fait une "table" de stat pour chaque enemy qu'on ira changer à chaque fois ?
	# Choix le plus modulable, apparemment ?
	# Mix de "become_veteran" et "become_boss" sur le script zombie, en somme.
	# Quel stats doivent être changées par le setup : 
	# speed
	# strength
	# health
	# burning
	# burning timer
	# inventory ????
	pass
