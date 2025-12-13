extends Area2D

var faced_direction: Vector2 = Vector2()
var speed: int = 200
var base_dmg: int
var dmg_calculated: float

# Set in apply_buffs() via getting active_buffs in GLOBALS singleton
var atk_multiplier = 1.0
var atk_boost = 0
var penetration: bool = false
var penetration_depth: int = 0
var explosive_bullet: bool = false
var fire_bullet: bool = false

@export var explosion_scn: PackedScene
@onready var player: Node = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	base_dmg = int(globals.weapons[player.equipped_weapon].attack)
	apply_buffs()
	dmg_calculated = (base_dmg + atk_boost) + (base_dmg + atk_boost) * (atk_multiplier/10)
	
	%sprite.texture = load(globals.weapons[player.equipped_weapon].bullet_sprite)
	%light.color = Color(globals.weapons[player.equipped_weapon].light_color)

func _process(delta: float) -> void:
	translate(faced_direction * speed * delta)

func apply_buffs() ->void:
	atk_boost = globals.get_active_buff_level("attack_raw")
	atk_multiplier = globals.get_active_buff_level("attack_multiplier")
	
	var pierce_level: int = globals.get_active_buff_level("piercing")
	if pierce_level > 0:
		penetration = true
		penetration_depth = pierce_level
	
	if globals.get_active_buff_level("fire") > 0:
		fire_bullet = true
	
	if globals.get_active_buff_level("explosive") > 0:
		explosive_bullet = true

func shoot(target_position: Vector2, player_position: Vector2) -> void:
	position = player_position
	faced_direction = (target_position - player_position).normalized()
	rotation = faced_direction.angle()

func _on_Bullet_body_entered(body: Object) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("hit"):
			
			if explosive_bullet:
				var explosion = explosion_scn.instantiate()
				explosion.position = self.position
				get_tree().get_root().call_deferred('add_child', explosion)
				#This line can be changed to have it explode at each body collided with
				explosive_bullet = false
			
			body.hit(dmg_calculated)
			
			# IGNITING BULLET
			if fire_bullet and body.has_method("on_fire"):
				body.on_fire()
				
			# PENETRATING BULLET
			if !penetration:
				queue_free()
			else:
				penetration_depth -= 1
				if penetration_depth < 0:
					queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
