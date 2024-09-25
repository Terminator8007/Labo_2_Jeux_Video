extends CharacterBody2D

@export var speed = 400
@export var bullet_scene : PackedScene

func get_input():
	look_at(get_global_mouse_position())
	
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir * speed
	
	if Input.is_action_just_pressed("shoot"):
		_shoot()

func _physics_process(delta):
	get_input()
	wrap_around_screen()
	move_and_slide()
	
func _shoot():
	var nbBullet = get_tree().get_nodes_in_group("bullet").size()
	if nbBullet < 11:
		var b = bullet_scene.instantiate()
		get_parent().add_child(b)
		b.global_transform = $Muzzle.global_transform

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		$Sprite2D.visible = false
		$Timer.start()

func get_random_safe_position() -> Vector2:
	var screen_rect = get_viewport_rect()
	var random_position = Vector2()
	var is_safe = false
	
	while not is_safe:
		random_position.x = randf_range(screen_rect.position.x, screen_rect.end.x)
		random_position.y = randf_range(screen_rect.position.y, screen_rect.end.y)
		
		is_safe = true
		
		for enemy in get_tree().get_nodes_in_group("mobs"):
			if random_position.distance_to(enemy.position) < 100:
				is_safe = false
				break
	return random_position

func wrap_around_screen():
	position.x = wrapf(position.x, -35, 1955)
	position.y = wrapf(position.y, -35, 1115)


func _on_timer_timeout() -> void:
	var new_position = get_random_safe_position()
	$Sprite2D.visible = true
	$Timer.stop()
	position = new_position
	
