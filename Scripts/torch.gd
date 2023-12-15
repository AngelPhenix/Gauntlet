extends StaticBody2D

export var blue_color: Color
export var red_color: Color
export var green_color: Color

onready var torch_colors: Array = [red_color, green_color, blue_color]

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var index: int = rng.randi_range(0, torch_colors.size()-1)
	$sprite.frame = index
	$light.color = torch_colors[index]


#func _ready():
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var index: int = rng.randi_range(0, torch_colors.size()-1)
#	$sprite.modulate = torch_colors[index]
#	$light.color = torch_colors[index]
