extends AnimatableBody2D

var is_luigi = false
var points = 1


func _ready():
	if is_luigi:
		$Sprite2D.sprite_frames = load("res://game_scenes/whack_mole/hittable_luigi.tres")
		points = -3
