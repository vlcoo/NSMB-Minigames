extends Area2D

const SPEED: int = 40

var direction_angle: float = 0


func _physics_process(delta: float) -> void:
	position += Vector2(1, 0).rotated(direction_angle) * SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
