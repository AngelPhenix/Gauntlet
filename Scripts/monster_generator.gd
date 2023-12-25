extends Node

var screen_w_size: int
var screen_h_size: int
var spawning_margin: int = 150
var number_of_mobs: int = 10
var spawn

var zombie_scn: PackedScene = preload("res://Scenes/Zombie.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_w_size = OS.window_size.x
	screen_h_size = OS.window_size.y
	
	for i in number_of_mobs:
		var zombie = zombie_scn.instance()
		randomize()
		var rdm = rand_range(0,1)
		if rdm < 0.5:
			zombie.position.x = rand_range(-spawning_margin, 0)
		else:
			zombie.position.x = rand_range(screen_w_size, screen_w_size + spawning_margin)
		
		rdm = rand_range(0,1)
		if rdm < 0.5:
			zombie.position.y = rand_range(-spawning_margin, 0)
		else:
			zombie.position.y = rand_range(screen_h_size, screen_h_size + spawning_margin)
		
		add_child(zombie)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
