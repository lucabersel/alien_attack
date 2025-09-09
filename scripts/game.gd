extends Node2D

var lives = 3
var score = 0

var game_over_screen = preload("res://scenes/game_over_screen.tscn")

@onready var ship = $Ship
@onready var hud = $UI/HUD

@onready var enemy_hit_sound = $EnemyHitSound
@onready var player_was_hit = $PlayerDamageSound

func _ready() -> void:
	hud.set_score_label(score)
	hud.set_lives(lives)

func _on_deathzone_area_entered(area: Area2D) -> void:
	area.queue_free()

func _on_ship_took_damage() -> void:
	lives -= 1
	player_was_hit.play()
	hud.set_lives(lives)
	if lives == 0:
		ship.die()
		
		await get_tree().create_timer(1.0).timeout
		
		var go_instance = game_over_screen.instantiate()
		go_instance.set_score(score)
		$UI.add_child(go_instance)

func _on_enemy_spawner_enemy_spawned(enemy_instance: Variant) -> void:
	enemy_instance.connect("died", _on_enemy_died)
	add_child(enemy_instance)

func _on_enemy_died():
	score += 100
	hud.set_score_label(score)
	enemy_hit_sound.play()

func _on_enemy_spawner_path_emeny_spawned(path_enemy_instance: Variant) -> void:
	add_child(path_enemy_instance)
	path_enemy_instance.enemy.connect("died", _on_enemy_died)
