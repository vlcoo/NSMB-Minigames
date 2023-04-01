extends Node

const SOUNDS: Dictionary = {
	"mole_hit": preload("res://game_scenes/whack_mole/assets/audio/NCS_SE_VS_MOG_CHOROHIT.ogg"),
	"luigi_hit_0": preload("res://game_scenes/whack_mole/assets/audio/NCS_SE_VO_GRASP_L.ogg"),
	"luigi_hit_1": preload("res://game_scenes/whack_mole/assets/audio/NCS_SE_VO_DAMAGE_S_L.ogg"),
	"luigi_hit_2": preload("res://game_scenes/whack_mole/assets/audio/NCS_SE_VO_DAMAGE_H_L_MG.ogg"),
	"luigi_hit_3": preload("res://game_scenes/whack_mole/assets/audio/NCS_SE_VO_FALL_L.ogg")
}

var hittable = preload("res://game_scenes/whack_mole/entities/hittable.tscn")


func _ready():
	DBs.SCENE_PRELOADS.sounds = SOUNDS
	DBs.SCENE_PRELOADS.anim_luigi = preload("res://game_scenes/whack_mole/hittable_luigi.tres")
	DBs.SCENE_PRELOADS.luigi_hits = 0
	DBs.SCENE_PRELOADS.anim_speed = 1


func spawn_new_target():
	var target: Area2D = hittable.instantiate()
	target.is_luigi = randi() % 2
	target.global_position = $"2D/BGBottom/Mask".get_children()[randi() % $"2D/BGBottom/Mask".get_child_count()].global_position
	$"2D".add_child(target)
	target.hit.connect($HUDOverlay._on_points_sum_specific.bind(target.points))


func _on_timer_timeout():
	spawn_new_target()
#	DBs.SCENE_PRELOADS.anim_speed += 0.01
#	$Timer.wait_time -= 0.01


func _on_hud_overlay_time_up():
	$Timer.stop()
	$ResultsOverlay.appear()
