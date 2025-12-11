extends Control

@export var debug_mode: bool = false

@onready var player: Node = get_tree().get_nodes_in_group("player")[0]
@onready var gameoverhud: PackedScene = preload("res://Scenes/Interface/GameOverHUD.tscn")
var weapons: Array = []
var exp_total: int = 0
var exp_required: int

func _ready() -> void:
	player.coin_pickedup.connect(_on_coin_pickedup)
	player.hurt.connect(_on_player_hurt)
	player.exp_pickedup.connect(_on_player_add_experience)
	player.dead.connect(_on_player_dead)
	
	exp_required = get_required_experience(player.level + 1)
	_update_hud()

func _update_hud() -> void:
	$CoinCounter/MarginContainer/HBoxContainer/number.text = str(globals.total_coins_collected)
	$hp.max_value = player.max_health
	$hp.value = player.health
	$Exp_Bar.max_value = exp_required
	$Exp_Bar.value = player.experience


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lvlup") && debug_mode:
		player.levelup()
		$Level.text = "Lv." + str(player.level)

func _on_coin_pickedup(total_coins: int) -> void:
	$CoinCounter/MarginContainer/HBoxContainer/number.text = str(total_coins)

func _on_player_hurt(new_health: int) -> void:
	$hp.value = new_health

func _on_player_dead() -> void:
	get_tree().paused = true
	var go_hud: Node = gameoverhud.instantiate()
	add_child(go_hud)

func get_required_experience(level: int) -> float:
	return round(pow(level, 1.8) + level * 4)
	
func _on_player_add_experience(exp_gained: int) -> void:
	if player.experience + exp_gained < exp_required:
		player.experience += exp_gained
		$Exp_Bar.value = player.experience
	else:
		player.levelup()
		player.experience = player.experience - exp_required
		$Level.text = "Lv." + str(player.level)
		$Exp_Bar.value = player.experience
		exp_required = get_required_experience(player.level + 1)
		$Exp_Bar.max_value = exp_required
