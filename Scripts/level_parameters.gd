extends Node2D

const spawner_scn: PackedScene = preload("res://Scenes/Spawner.tscn")
const torch_scn: PackedScene = preload("res://Scenes/Torch.tscn")
const chest_scn: PackedScene = preload("res://Scenes/Chest.tscn")
const teleporter_scn: PackedScene = preload("res://Scenes/Teleporter.tscn")
const weapon_start_scn: PackedScene = preload("res://Scenes/ChooseWeapon.tscn")
var already_chosen_tile: Array
onready var player: Node = get_tree().get_nodes_in_group("player")[0]
onready var map: TileMap = get_tree().get_nodes_in_group("map")[0]

export var min_spawner_possible: int = 2
export var max_spawner_possible: int = 6
export var torches_visible: bool = true

func _ready() -> void:
	randomize()
	_generate_map()
	if globals.level == 1:
		_choose_weapon()
	# Aller chercher son propre nom, récupérer l'int de fin (les ints?) et le feed a globals.level_number

# Checks every tile with ID 2 (floor_spawn) to be a potential spawner tile
func _generate_map() -> void:
	# COMMENTER POUR REVENIR A UN SOL CLEAN
	# TILES THAT SPAWN MOBS (ID-2)
	# CRACKED TILES BETWEEN 8 AND 11
	var possible_spawner_tile: Array = map.get_used_cells_by_id(2)
#	generate_enemy_spawners(possible_spawner_tile)
	for tile in possible_spawner_tile:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var tile_num = rng.randi_range(8, 11)
		rng.randomize()
		var probability = rng.randi_range(0, 100)
		if probability <= 5:
			map.set_cellv(tile, tile_num)
	
	# FLOOR (ID-0) WHICH DOESN'T SPAWN MOBS
	var floor_tiles_to_modify: Array = map.get_used_cells_by_id(0)
	for tile in floor_tiles_to_modify:
		map.set_cellv(tile, 2)
	
	# TORCHES (ID-3)
	if torches_visible:
		var torch_container: Node2D = Node2D.new()
		torch_container.add_to_group("torches")
		torch_container.name = "TorchContainer"
		add_child(torch_container)
		for tile in map.get_used_cells_by_id(3):
			var torch: Node = torch_scn.instance()
			torch.global_position = map.map_to_world(tile) + map.cell_size/2
			get_tree().get_nodes_in_group("torches")[0].add_child(torch)

	# CHEST (ID-12)
	var chest_container: Node2D = Node2D.new()
	chest_container.add_to_group("chests")
	chest_container.name = "ChestContainer"
	add_child(chest_container)
	for tile in map.get_used_cells_by_id(12):
		var chest: Node = chest_scn.instance()
		chest.global_position = map.map_to_world(tile) + map.cell_size/2
		get_tree().get_nodes_in_group("chests")[0].add_child(chest)

	# TP (ID-5)
	for tile in map.get_used_cells_by_id(5):
		var tp: Node = teleporter_scn.instance()
		tp.global_position = map.map_to_world(tile)
		add_child(tp)

func _choose_weapon() -> void:
	get_tree().paused = true
	var weapons_panel = weapon_start_scn.instance()
	add_child(weapons_panel)
	weapons_panel.pause_mode = Node.PAUSE_MODE_PROCESS

func generate_enemy_spawners(tile_positions: Array) -> void:
	# SPAWNERS (ID-2)
	var spawn_container: Node2D = Node2D.new()
	spawn_container.add_to_group("spawner")
	spawn_container.name = "SpawnContainer"
	add_child(spawn_container)
	var number_of_spawners: int = int(rand_range(min_spawner_possible, max_spawner_possible))
	globals.spawn_to_destroy = number_of_spawners
	for i in number_of_spawners:
		var spawner: Node = spawner_scn.instance()
		var num_picked = rand_range(0,tile_positions.size())
		var chosen_tile = tile_positions[num_picked]
		# If the tile has already been picked, choose another one
		while already_chosen_tile.has(chosen_tile):
			num_picked = rand_range(0,tile_positions.size())
			chosen_tile = tile_positions[num_picked]
		already_chosen_tile.append(chosen_tile)
		
		spawner.global_position = map.map_to_world(chosen_tile) + map.cell_size/2
		get_tree().get_nodes_in_group("spawner")[0].add_child(spawner)

# Is called when the weapon has been chosen and the game can start.
# The signal is emitted by PanelWeaponChoosing on click on one of the panels appearing at the start
func game_start() -> void:
	get_tree().paused = false
