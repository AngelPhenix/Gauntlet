extends Node

var screen_w_size: int = 960
var screen_h_size: int = 960
var spawning_margin: int = 250
var number_of_mobs: int = 6

# 1% chance to spawn a boss
var enemy_proba_boss: int = 1
# 5% chance to spawn a veteran (6%-1% for the boss leaves 5%)
var enemy_proba_veteran: int = 6

@export var zombie_scn: PackedScene
@onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready():
	randomize()
	_on_Tick_timeout()

func _on_Tick_timeout():
	for i in number_of_mobs:
		var zombie = zombie_scn.instantiate()
		var rdm = randf_range(0,1)
		
		var left_side_screen: float = player.global_position.x - (screen_w_size/2)
		var right_side_screen: float = player.global_position.x + (screen_w_size/2)
		var top_side_screen: float = player.global_position.y - (screen_h_size/2)
		var bot_side_screen: float = player.global_position.y + (screen_h_size/2)
		
		var random_x_pos: float = randf_range(left_side_screen - spawning_margin, 
		right_side_screen + spawning_margin)
		
		# Si point horizontal est dans le screen joueur : Le faire spawn en dehors du screen verticalement
		if random_x_pos > left_side_screen && random_x_pos < right_side_screen:
			zombie.position.x = random_x_pos
			#Top
			if rdm < 0.5:
				zombie.position.y = randf_range(top_side_screen - spawning_margin, top_side_screen)
			#Bottom
			else:
				zombie.position.y = randf_range(bot_side_screen, bot_side_screen + spawning_margin)
		# Le point n'est pas dans l'écran, on peut prendre n'importe quelle valeur verticale entre min et max
		else:
			zombie.position.x = random_x_pos
			zombie.position.y = randf_range(top_side_screen - spawning_margin,
			bot_side_screen + spawning_margin)
		
		# roll entre 1 et 100
		var proba: int = randi() % 100 + 1
		if proba <= enemy_proba_boss:
			zombie.boss = true
		elif proba <= enemy_proba_veteran:
			zombie.veteran = true
		add_child(zombie)
