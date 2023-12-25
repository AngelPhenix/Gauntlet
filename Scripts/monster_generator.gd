extends Node

var screen_w_size: int
var screen_h_size: int
var spawning_margin: int = 150
var number_of_mobs: int = 10
var spawn

var zombie_scn: PackedScene = preload("res://Scenes/Zombie.tscn")
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready():
	randomize()
	screen_w_size = OS.window_size.x
	screen_h_size = OS.window_size.y

func _on_Tick_timeout():
	for i in number_of_mobs:
		var zombie = zombie_scn.instance()
		var rdm = rand_range(0,1)
		if rdm < 0.5:
			zombie.position.x = rand_range(-spawning_margin, 0)
		else:
			zombie.position.x = rand_range(screen_w_size, screen_w_size + spawning_margin)
		print(rdm)
		
		rdm = rand_range(0,1)
		if rdm < 0.5:
			zombie.position.y = rand_range(-spawning_margin, 0)
		else:
			zombie.position.y = rand_range(screen_h_size, screen_h_size + spawning_margin)
		
		add_child(zombie)
