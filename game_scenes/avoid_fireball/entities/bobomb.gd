extends Area2D

var is_detonated: bool = false
signal detonated

@export var bounds_left_marker: Marker2D
@export var bounds_right_marker: Marker2D
@export var bounds_up_marker: Marker2D
@export var bounds_down_marker: Marker2D

var bounds_left: float = -INF
var bounds_right: float = INF
var bounds_up: float = -INF
var bounds_down: float = INF

func _ready() -> void:
	if bounds_left_marker != null: bounds_left = bounds_left_marker.global_position.x
	if bounds_right_marker != null: bounds_right = bounds_right_marker.global_position.x
	if bounds_up_marker != null: bounds_up = bounds_up_marker.global_position.y
	if bounds_down_marker != null: bounds_down = bounds_down_marker.global_position.y


func _process(delta: float) -> void:
	if is_detonated: return

	var mouse_pos: Vector2 = get_global_mouse_position()
	mouse_pos.x = max(mouse_pos.x, bounds_left)
	mouse_pos.x = min(mouse_pos.x, bounds_right)
	mouse_pos.y = max(mouse_pos.y, bounds_up)
	mouse_pos.y = min(mouse_pos.y, bounds_down)
	position = mouse_pos


func _on_area_entered(area: Area2D) -> void:
	if is_detonated: return

	is_detonated = true
	$AnimationPlayer.play("detonate")
	await $AnimationPlayer.animation_finished
	emit_signal("detonated")
