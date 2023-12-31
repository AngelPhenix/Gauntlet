extends KinematicBody2D

# variables
var speed: int = 150
var max_health: int = 20
var health: int = 20
var coins: int = 0
var velocity: Vector2 = Vector2()
var invincibility_frame: float = 0.50
var body_should_damage_us_map: Dictionary
var level: int = 1

var experience: int

var equipped_weapon: String
var weapons_in_inventory: Array

var nearby_chest: Node
var bullet_scn: PackedScene = preload("res://Scenes/Bullet.tscn")
onready var interface: Node = get_tree().get_nodes_in_group("interface")[0]
onready var inventory: Node = get_tree().get_nodes_in_group("inventory")[0]
var levelup_panel_scn = preload("res://Scenes/Interface/Levelup.tscn")

var can_fire: bool = true
var shoot: bool = true
var is_playing: bool = false
var touching_enemy: bool = false

var buffs: Dictionary = {}

signal hurt(health)
signal coin_pickedup(value)
signal exp_pickedup(value)

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide(velocity.normalized() * speed)
	rotation += get_local_mouse_position().angle()
#	var target_offset = (get_global_mouse_position() - global_position)/4
#	$camera.offset = $camera.offset.linear_interpolate(target_offset, delta * 8.0)

func get_input() -> void:
	velocity = Vector2()
	velocity.x = -int(Input.is_action_pressed('ui_left')) + int(Input.is_action_pressed('ui_right'))
	velocity.y = -int(Input.is_action_pressed('ui_up')) + int(Input.is_action_pressed('ui_down'))
	if velocity != Vector2():
		if !is_playing:
			($anim as AnimationPlayer).play('walk')
			is_playing = true
	else:
		($anim as AnimationPlayer).stop()
		is_playing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_down") && can_fire:
		shooting()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func shooting() -> void:
	can_fire = false
	($audio/gunshot as AudioStreamPlayer2D).play()
	var bullet: Node = bullet_scn.instance()
	get_tree().get_root().add_child(bullet)
	bullet.shoot(get_global_mouse_position(), global_position)
	bullet.get_node("sprite").texture = load(globals.weapons[equipped_weapon]["bullet_sprite"])
	bullet.get_node("light").color = Color(globals.weapons[equipped_weapon]["light_color"])
	($shoot_rate as Timer).start()

func weapon_swapped(weapon_name_in_inv: String) -> void:
	equipped_weapon = weapon_name_in_inv

func weapon_picked_up(weapon_name: String) -> void:
	if weapons_in_inventory.size() == 0:
		equipped_weapon = weapon_name
	weapons_in_inventory.append(weapon_name)
	interface._on_Interface_weapon_pickedup(weapon_name)

func add_coins(value: int) -> void:
	globals.total_coins_collected += value
	emit_signal("coin_pickedup", globals.total_coins_collected)
	($audio/treasure as AudioStreamPlayer2D).play()

func add_experience(value: int) -> void:
	experience += value
	emit_signal("exp_pickedup", value)
	($audio/treasure as AudioStreamPlayer2D).play()

func _on_hitbox_body_entered(body: Object) -> void:
	# If the body hit is an enemy
	if body.is_in_group("enemy"):
		# if the enemy is already in the dictionary but not erase, its because the
		# yield isn't done yet and thus, to not get spammed by damages
		if body_should_damage_us_map.has(body):
			# we are already looping, just notify the loop to keep damaging
			body_should_damage_us_map[body] = true
		# if the enemy is not in the dictionary : add it to it
		else:
			# no loop yet, so start one now
			body_should_damage_us_map[body] = true
			# While the body is in the dictionary, take damage every 0.33 sec
			while body_should_damage_us_map[body]:
				($audio/hurt as AudioStreamPlayer2D).play()
				health -= body.strength
				if health <= 0:
					print("Death !!!!!!!")
				emit_signal("hurt", health)
				yield(get_tree().create_timer(invincibility_frame), "timeout")
			# Not in loop anymore, meaning body is not near us / is dead : No more damage, kick it from dic
			body_should_damage_us_map.erase(body)

func _on_hitbox_body_exited(body: Object) -> void:
	if body.is_in_group("enemy"):
		body_should_damage_us_map[body] = false # tell our loop to stop damaging

func levelup() -> void:
	level += 1
	get_tree().paused = true
	var panel = levelup_panel_scn.instance()
	add_child(panel)
	panel.pause_mode = Node.PAUSE_MODE_PROCESS

func buff_collected(name: String) -> void:
	var hasBuff: bool = false
	# Will execute only if the buff is already in the dictionary
	for buff in buffs:
		if buff == name:
			buffs[buff] += 1
			hasBuff = true
	# Will execute only if the buff isn't in the dictionary and initialize it to 1
	if hasBuff == false:
		buffs[name] = 1


func _on_shoot_rate_timeout():
	can_fire = true
	if(Input.is_action_pressed("mouse_down") && can_fire):
		shooting()
		($shoot_rate as Timer).start()
