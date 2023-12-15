extends StaticBody2D

onready var blue_sprite = preload("res://Sprites/bluetorch.png")
onready var red_sprite = preload("res://Sprites/redtorch.png")
onready var green_sprite = preload("res://Sprites/greentorch.png")

export var blue_color: Color
export var red_color: Color
export var green_color: Color

func _ready():
	
	var torch_settings: Dictionary = {
		0 : {
			"sprite" : "res://Sprites/bluetorch.png",
			"color" : blue_color
		},
		1 : {
			"sprite" : "res://Sprites/redtorch.png",
			"color" : red_color
		},
		2 : {
			"sprite" : "res://Sprites/greentorch.png",
			"color" : green_color
		}
	}
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var index: int = rng.randi_range(0, torch_settings.size()-1)
	$sprite.texture = load(torch_settings[index]["sprite"])
	$light.color = torch_settings[index]["color"]
