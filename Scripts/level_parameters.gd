extends Node2D

const weapon_start_scn: PackedScene = preload("res://Scenes/ChooseWeapon.tscn")

onready var fragment_scn: PackedScene = preload("res://Scenes/TileFragment.tscn")

var player_frag_position: Vector2 = Vector2(0, 0)
var player_frag: Node

func _ready() -> void:
	randomize()
#	_generate_cracks()
	_choose_weapon()

# Checks every tile with ID 2 (floor_spawn) to be a potential cracked tile with a 2% chance
func _generate_cracks() -> void:
	for fragment in $Map.get_children():
		for tile in fragment.get_used_cells_by_id(2):
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var tile_num = rng.randi_range(8, 11)
			rng.randomize()
			var probability = rng.randi_range(0, 100)
			if probability <= 2:
				fragment.set_cellv(tile, tile_num)


func generate_new_fragments(new_player_pos: Vector2) -> void:
	var fragments: Array = $Map.get_children()
	var new_frags: Array
	
	# Player went left
	if new_player_pos.x < player_frag_position.x:
		for fragment in fragments:
			if fragment.position.x > player_frag_position.x:
				var new_opposite_fragment: Node = fragment_scn.instance()
				new_opposite_fragment.position = Vector2(new_player_pos.x - (fragment.get_used_rect().size.x * fragment.cell_size.x), fragment.position.y)
				fragments.append(new_opposite_fragment)
				new_frags.append(new_opposite_fragment)
				fragment.queue_free()
	
	# Player went right
	if new_player_pos.x > player_frag_position.x:
		for fragment in fragments:
			if fragment.position.x < player_frag_position.x:
				var new_opposite_fragment: Node = fragment_scn.instance()
				new_opposite_fragment.position = Vector2(new_player_pos.x + (fragment.get_used_rect().size.x * fragment.cell_size.x), fragment.position.y)
				fragments.append(new_opposite_fragment)
				new_frags.append(new_opposite_fragment)
				fragment.queue_free()
	
	# Player went up
	if new_player_pos.y < player_frag_position.y:
		for fragment in fragments:
			if fragment.position.y > player_frag_position.y:
				var new_opposite_fragment: Node = fragment_scn.instance()
				new_opposite_fragment.position = Vector2(fragment.position.x, new_player_pos.y - (fragment.get_used_rect().size.y * fragment.cell_size.y))
				fragments.append(new_opposite_fragment)
				new_frags.append(new_opposite_fragment)
				fragment.queue_free()
	
	if new_player_pos.y > player_frag_position.y:
		for fragment in fragments:
			if fragment.position.y < player_frag_position.y:
				var new_opposite_fragment: Node = fragment_scn.instance()
				new_opposite_fragment.position = Vector2(fragment.position.x, new_player_pos.y + (fragment.get_used_rect().size.y * fragment.cell_size.y))
				fragments.append(new_opposite_fragment)
				new_frags.append(new_opposite_fragment)
				fragment.queue_free()
	
	player_frag_position = new_player_pos
	
	_draw_new_map_from_array(new_frags)
	_clean_map(fragments)


func _draw_new_map_from_array(array_to_draw_with: Array) -> void:
	for frags in array_to_draw_with:
		$Map.call_deferred("add_child", frags)

func _clean_map(map_to_clean: Array) -> void:
	for map in map_to_clean:
		if map.position.x > player_frag_position.x + 320:
			map.queue_free()
		if map.position.x < player_frag_position.x - 320:
			map.queue_free()
		if map.position.y > player_frag_position.y + 320:
			map.queue_free()
		if map.position.y < player_frag_position.y - 320:
			map.queue_free()

func _choose_weapon() -> void:
	get_tree().paused = true
	var weapons_panel = weapon_start_scn.instance()
	add_child(weapons_panel)
	weapons_panel.pause_mode = Node.PAUSE_MODE_PROCESS

# Is called when the weapon has been chosen and the game can start.
# The signal is emitted by PanelWeaponChoosing on click on one of the panels appearing at the start
func game_start() -> void:
	get_tree().paused = false
