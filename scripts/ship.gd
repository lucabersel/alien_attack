extends CharacterBody2D

signal took_damage

var moveSpeed = 300
var rocket_scene = preload("res://scenes/rocket.tscn")
@onready var rocket_container = $RocketContainer #get_node("RocketContainer")
@onready var fire_timer = $FireTimer
@onready var player_shoot_sound = $PLayerShootSound

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("moveUp"):
		velocity.y = -moveSpeed
	if Input.is_action_pressed("moveDown"):
		velocity.y = moveSpeed
	if Input.is_action_pressed("moveRight"):
		velocity.x = moveSpeed
	if Input.is_action_pressed("moveLeft"):
		velocity.x = -moveSpeed
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	global_position = global_position.clamp(
		Vector2(40, 52), 
		Vector2(screen_size.x - 40, screen_size.y - 52)
	)
	
func shoot():
	if not fire_timer.is_stopped():
		return

	fire_timer.start()

	var rocket_instance = rocket_scene.instantiate()
	rocket_container.add_child(rocket_instance)
	rocket_instance.global_position = global_position
	rocket_instance.global_position.x += 80
	player_shoot_sound.play()
	
func take_damage():
	emit_signal("took_damage")
	
func die():
	queue_free()
