extends Area2D

var faced_direction: Vector2 = Vector2()
var speed: int = 200
var base_dmg = 1
var dmg_calculated: float
var atk_multiplier = 1.0
var atk_boost = 0
var buffed = false

onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	base_dmg = int(globals.weapons[player.equipped_weapon]["attack"])
	for buff in player.buffs.keys():
		if buff == "attack_raw":
			atk_boost = player.buffs["attack_raw"]
		if buff == "attack_multiplier":
			atk_multiplier += player.buffs["attack_multiplier"]
	dmg_calculated = (base_dmg + atk_boost) + (base_dmg + atk_boost) * (atk_multiplier/10)

func _process(delta: float) -> void:
	translate(faced_direction * speed * delta)

func shoot(target_position: Vector2, player_position: Vector2) -> void:
	position = player_position
	faced_direction = (target_position - player_position).normalized()
	rotation = faced_direction.angle()

func _on_Bullet_body_entered(body: Object) -> void:
	if body is TileMap:
		queue_free()
	if body.is_in_group("wall"):
		queue_free()
	if body.is_in_group("enemy"):
		if body.has_method("hit"):
			body.hit(dmg_calculated)
			if !buffed:
				queue_free()

func _on_Bullet_area_entered(area: Object) -> void:
	if area.is_in_group("enemy"):
		if area.has_method("hit"):
			area.hit(dmg_calculated)
			if !buffed:
				queue_free()
