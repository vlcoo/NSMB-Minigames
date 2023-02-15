extends Area2D

var is_luigi = false
var points = 1
var already_hit = false
var luigi_number_hit = 0


func _ready():
	if is_luigi:
		$CollisionShape2D/Sprite2D.sprite_frames = DBs.SCENE_PRELOADS.anim_luigi
		$AudioStreamPlayer2D.stream = DBs.SCENE_PRELOADS.sounds["luigi_hit_" + str(calc_luigi_hit_sound())]
		points = -3

	$Label.text = ("+ " if points >= 0 else "- ") + str(abs(points))
	$AnimationPlayer.speed_scale = DBs.SCENE_PRELOADS.anim_speed


func calc_luigi_hit_sound() -> int:
	if DBs.SCENE_PRELOADS.luigi_hits >= 19:
		DBs.SCENE_PRELOADS.luigi_hits = 0
	if DBs.SCENE_PRELOADS.luigi_hits < 6:
		return 0
	return floor((DBs.SCENE_PRELOADS.luigi_hits - 6) / 6) + 1


func _on_input_event(viewport, event, shape_idx):
	if already_hit: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		$AnimationPlayer.play("hit")
		already_hit = true


func _on_animation_in_finished():
	if already_hit:
		$CollisionShape2D/Sprite2D.visible = false
		if is_luigi: DBs.SCENE_PRELOADS.luigi_hits += 1
		if points > 0:
			$AnimationPlayer.play("number_positive")
		elif points < 0:
			$AnimationPlayer.play("number_negative")
	else:
		queue_free()
