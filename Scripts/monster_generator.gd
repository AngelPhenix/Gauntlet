extends Node

var screen_w_size: int = 320
var screen_h_size: int = 320
var spawning_margin: int = 10
var number_of_mobs: int = 10
var spawn

var zombie_scn: PackedScene = preload("res://Scenes/Zombie.tscn")
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready():
	randomize()
#	screen_w_size = OS.window_size.x
#	screen_h_size = OS.window_size.y

func _on_Tick_timeout():
	for i in number_of_mobs:
		var zombie = zombie_scn.instance()
		var rdm = rand_range(0,1)
		
		#Horizontal position
		#Left
		if rdm < 0.5:
			zombie.position.x = rand_range(player.global_position.x - (screen_w_size/2) - spawning_margin, 
			player.global_position.x - (screen_w_size/2))
		#Right
		else:
			zombie.position.x = rand_range(player.global_position.x + (screen_w_size/2), 
			player.global_position.x + (screen_w_size/2) + spawning_margin)
		
		rdm = rand_range(0,1)
		#Top
		if rdm < 0.5:
			zombie.position.y = rand_range(player.global_position.y - (screen_h_size/2) - spawning_margin, 
			player.global_position.y - (screen_h_size/2))
		#Bottom
		else:
			zombie.position.y = rand_range(player.global_position.y + (screen_h_size/2), 
			player.global_position.y + (screen_h_size/2) + spawning_margin)
		
		add_child(zombie)
