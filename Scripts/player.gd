extends CharacterBody2D

# variables
var speed: int = 300
var max_health: int = 5
var health: int = 5
var invincibility_frame: float = 0.50
var body_should_damage_us_map: Dictionary
var level: int = 1
var experience: int
var exp_required: float
var equipped_weapon: String

@export var bullet_scn: PackedScene
@export var hud_levelup_scn: PackedScene
@onready var interface: Node = get_tree().get_nodes_in_group("interface")[0]

var can_fire: bool = true
var shoot: bool = true
var is_playing: bool = false

signal hurt(health)
signal reset_hp(health)
signal exp_init
signal coin_pickedup(value)
signal exp_pickedup
signal level_up
signal dead

func _ready() -> void:
	exp_required = get_required_experience(level)
	exp_init.emit(exp_required)
	stat_check()

func _physics_process(delta: float) -> void:
	get_input()
	set_velocity(velocity.normalized() * speed)
	move_and_slide()
	rotation += get_local_mouse_position().angle()

func get_input() -> void:
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

func shooting() -> void:
	can_fire = false
	($audio/gunshot as AudioStreamPlayer2D).play()
	var bullet: Node = bullet_scn.instantiate()
	get_parent().add_child(bullet)
	bullet.shoot(get_global_mouse_position(), global_position)
	($shoot_rate as Timer).start()

func equip(weapon_name: String) -> void:
	equipped_weapon = weapon_name

func add_coins(value: int) -> void:
	globals.current_coins += value
	emit_signal("coin_pickedup", globals.current_coins)
	($audio/treasure as AudioStreamPlayer2D).play()

func add_experience(value: int) -> void:
	if experience + value < exp_required:
		experience += value
		exp_pickedup.emit(experience)
	else:
		levelup()
	($audio/treasure as AudioStreamPlayer2D).play()

func levelup() -> void:
	level += 1
	experience = 0
	exp_required = get_required_experience(level)
	level_up.emit(level, exp_required)
	
	globals.get_node("levelup_music").play()
	globals.get_node("ingame_music").volume_db = -45
	
	get_tree().paused = true
	
	var hud_levelup = hud_levelup_scn.instantiate()
	add_child(hud_levelup)

func get_required_experience(level: int) -> float:
	return round(pow(level, 1.8) + level * 2)

func stat_check() -> void:
	max_health += globals.get_current_upgrade_effect("hp")
	health = max_health
	reset_hp.emit(max_health)

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
					# Signal caught by ?
					dead.emit()
				emit_signal("hurt", health)
				await get_tree().create_timer(invincibility_frame).timeout
			# Not in loop anymore, meaning body is not near us / is dead : No more damage, kick it from dic
			body_should_damage_us_map.erase(body)

func _on_hitbox_body_exited(body: Object) -> void:
	if body.is_in_group("enemy"):
		body_should_damage_us_map[body] = false # tell our loop to stop damaging

func _on_shoot_rate_timeout():
	can_fire = true
	if(Input.is_action_pressed("mouse_down") && can_fire):
		shooting()
		($shoot_rate as Timer).start()
