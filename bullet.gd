extends Node2D

var speed = 1000
var screen_rect

func _ready() -> void:
	screen_rect = get_viewport_rect()
	add_to_group("bullet")

func _physics_process(delta):
	position += transform.x * speed * delta
	destroy()

func _on_Bullet_body_entered(body: Node2D):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()

func destroy():
	if (self.position.x > screen_rect.size.x + 50) || (self.position.y > screen_rect.size.y + 50) || (self.position.y < -50) || (self.position.x < -50):
		remove_from_group("bullet")
		self.queue_free()
