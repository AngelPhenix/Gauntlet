extends Node

var screen_w_size: int = 320
var screen_h_size: int = 320
var spawning_margin: int = 50
var number_of_mobs: int = 3
var spawn

var zombie_scn: PackedScene = preload("res://Scenes/Zombie.tscn")
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready():
	randomize()
	_on_Tick_timeout()

func _on_Tick_timeout():
	for i in number_of_mobs:
		var zombie = zombie_scn.instance()
		var rdm = rand_range(0,1)
		
		var left_side_screen: float = player.global_position.x - (screen_w_size/2)
		var right_side_screen: float = player.global_position.x + (screen_w_size/2)
		var top_side_screen: float = player.global_position.y - (screen_h_size/2)
		var bot_side_screen: float = player.global_position.y + (screen_h_size/2)
		
		var random_x_pos: float = rand_range(left_side_screen - spawning_margin, 
		right_side_screen + spawning_margin)
		
		# Si point horizontal est dans le screen joueur : Le faire spawn en dehors du screen verticalement
		if random_x_pos > left_side_screen && random_x_pos < right_side_screen:
			zombie.position.x = random_x_pos
			#Top
			if rdm < 0.5:
				zombie.position.y = rand_range(top_side_screen - spawning_margin, top_side_screen)
			#Bottom
			else:
				zombie.position.y = rand_range(bot_side_screen, bot_side_screen + spawning_margin)
		# Le point n'est pas dans l'écran, on peut prendre n'importe quel valeur vertical entre min et max
		else:
			zombie.position.x = random_x_pos
			zombie.position.y = rand_range(top_side_screen - spawning_margin,
			bot_side_screen + spawning_margin)
			
		add_child(zombie)
