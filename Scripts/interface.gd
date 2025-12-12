extends Control

@export var cheat_mode: bool = false
@onready var player: Node = get_tree().get_nodes_in_group("player")[0]
@onready var gameoverhud: PackedScene = preload("res://Scenes/Interface/GameOverHUD.tscn")

func _ready() -> void:
	player.coin_pickedup.connect(_on_coin_pickedup)
	player.exp_pickedup.connect(_on_player_update_experience)
	player.hurt.connect(_on_player_hurt)
	player.dead.connect(_on_player_dead)
	player.level_up.connect(_on_player_levelup)
	player.exp_init.connect(_on_player_ready)

	_update_hud()

func _on_player_ready(exp_max: float) -> void:
	%Exp_Bar.max_value = round(exp_max)

func _update_hud() -> void:
	%total_coins.text = str(globals.total_coins_collected)
	%hp.max_value = player.max_health
	%hp.value = player.health
	%Exp_Bar.value = player.experience

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lvlup") && cheat_mode:
		player.levelup()
		%Level.text = "Lv." + str(player.level)

func _on_coin_pickedup(total_coins: int) -> void:
	%total_coins.text = str(total_coins)

func _on_player_hurt(new_health: int) -> void:
	%hp.value = new_health

func _on_player_update_experience(experience: int) -> void:
	%Exp_Bar.value = experience

func _on_player_levelup(level: int, exp_max: float) -> void:
	%Level.text = "Lv." + str(level)
	%Exp_Bar.value = 0
	%Exp_Bar.max_value = round(exp_max)

func _on_player_dead() -> void:
	get_tree().paused = true
	var go_hud: Node = gameoverhud.instantiate()
	add_child(go_hud)
