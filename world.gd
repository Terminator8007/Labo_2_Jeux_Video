extends Node2D

var boid_scene : PackedScene = preload("res://boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_start_boid = randi_range(10, 20)
	
	for i in range(random_start_boid):
		_boid_spawn(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("clic"):
		_boid_spawn(true)
		
func _boid_spawn(random: bool) -> void:
	var boid = boid_scene.instantiate()
	var min_distance_from_player = 250
	var player_position = Vector2($Player.position)
	
	if random:
		var sprite = boid.get_node("Image")
		var random_color = Color(randf(), randf(), randf())
		sprite.modulate = random_color
	
	var random_position = _get_random_position_away_from_player(player_position, min_distance_from_player)
	boid.location = random_position
	
	add_child(boid)
	
	
func _get_random_position_away_from_player(player_position: Vector2, min_distance: int) -> Vector2:
	var random_position: Vector2
	
	while true:
		random_position = Vector2(randf_range(0, get_viewport_rect().size.x), randf_range(0, get_viewport_rect().size.y))
		
		if random_position.distance_to(player_position) >= min_distance:
			break
	
	return random_position
