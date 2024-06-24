extends PathFollow2D

@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D
var moving_grinding_sfx = preload("res://game_scenes/avoid_fireball/assets/audio/NCS_SE_VS_YOKE_KUPPA_LV.ogg")

var tween: Tween


func _ready() -> void:
	randomize()
	progress_ratio = randf()
	move_randomly()

func _process(delta: float) -> void:
	pass


func move_randomly() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.finished.connect(move_finished)
	sfx.stream = moving_grinding_sfx
	sfx.play()
	var destination_point := randf()
	tween.tween_property(self, "progress_ratio", destination_point, 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func move_finished() -> void:
	sfx.stop()
	$AnimationPlayer.play("start_fire")
