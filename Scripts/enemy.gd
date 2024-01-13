extends KinematicBody2D

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
