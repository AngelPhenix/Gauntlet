extends Node2D

const weapon_start_scn: PackedScene = preload("res://Scenes/ChooseWeapon.tscn")
onready var map: TileMap = get_tree().get_nodes_in_group("map")[0]

func _ready() -> void:
	randomize()
	_generate_map()
	_choose_weapon()

# Checks every tile with ID 2 (floor_spawn) to be a potential spawner tile
func _generate_map() -> void:
	# CRACKED TILES BETWEEN 8 AND 11
	var possible_spawner_tile: Array = map.get_used_cells_by_id(2)
#	generate_enemy_spawners(possible_spawner_tile)
	for tile in possible_spawner_tile:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var tile_num = rng.randi_range(8, 11)
		rng.randomize()
		var probability = rng.randi_range(0, 100)
		if probability <= 2:
			map.set_cellv(tile, tile_num)

func _choose_weapon() -> void:
	get_tree().paused = true
	var weapons_panel = weapon_start_scn.instance()
	add_child(weapons_panel)
	weapons_panel.pause_mode = Node.PAUSE_MODE_PROCESS

# Is called when the weapon has been chosen and the game can start.
# The signal is emitted by PanelWeaponChoosing on click on one of the panels appearing at the start
func game_start() -> void:
	get_tree().paused = false
