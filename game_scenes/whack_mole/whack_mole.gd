extends Node


func _ready():
	pass


func spawn_new_target():
	pass


func _on_timer_timeout():
	spawn_new_target()
#	DBs.SCENE_PRELOADS.anim_speed += 0.01
#	$Timer.wait_time -= 0.01


func _on_hud_overlay_time_up():
	$Timer.stop()
	$AudioMusic.volume_db = -6
	$ResultsOverlay.calc_and_store_scoreboard($HUDOverlay.points)
	$ResultsOverlay.appear()
