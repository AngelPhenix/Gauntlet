extends KinematicBody2D

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
var drop_table: Array = [globals.coin_scn, globals.exp_scn, globals.bonus_scn]
var label: PackedScene = preload("res://Scenes/Interface/DamageMobLabel.tscn")

onready var player: Object = get_tree().get_nodes_in_group("player")[0]
onready var blood_particle: PackedScene = preload("res://Scenes/Particles/BloodParticle.tscn")
