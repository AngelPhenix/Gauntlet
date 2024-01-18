extends Area2D

var faced_direction: Vector2 = Vector2()
var speed: int = 200
var base_dmg = 20
var dmg_calculated: float
var atk_multiplier = 1.0
var atk_boost = 0
var penetration: bool = false
var penetration_depth: int = 0

onready var explosion_scn: PackedScene = preload("res://Scenes/Explosion.tscn")

var explosive_bullet: bool = false
var fire_bullet: bool = false

onready var player: Node = get_tree().get_nodes_in_group("player")[0]

# Checks all the players buffs and act accordingly
func _ready() -> void:
	base_dmg = int(globals.weapons[player.equipped_weapon]["attack"])
	apply_buffs()
	dmg_calculated = (base_dmg + atk_boost) + (base_dmg + atk_boost) * (atk_multiplier/10)

func _process(delta: float) -> void:
	translate(faced_direction * speed * delta)

func apply_buffs() ->void:
	for buff in player.buffs.keys():
		if buff == "attack_raw":
			atk_boost = player.buffs["attack_raw"]
		if buff == "attack_multiplier":
			atk_multiplier += player.buffs["attack_multiplier"]
		if buff == "piercing":
			penetration = true
			penetration_depth = player.buffs["piercing"]
		if buff == "fire":
			fire_bullet = true
		if buff == "explosive":
			explosive_bullet = true

func shoot(target_position: Vector2, player_position: Vector2) -> void:
	position = player_position
	faced_direction = (target_position - player_position).normalized()
	rotation = faced_direction.angle()

func _on_Bullet_body_entered(body: Object) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("hit"):
			
			if explosive_bullet:
				var explosion = explosion_scn.instance()
				explosion.position = self.position
				explosion.damage = player.buffs["explosive"] * 3
				get_tree().get_root().call_deferred('add_child', explosion)
				explosive_bullet = false
			
			body.hit(dmg_calculated)
			
			if fire_bullet:
				body.on_fire()

			if !penetration:
				queue_free()
				
			else:
				penetration_depth -= 1
				if penetration_depth < 0:
					queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
