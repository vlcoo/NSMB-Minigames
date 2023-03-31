extends Control

enum ScoreTypes {EXPLICIT_TEXT, STAR_COUNT}

@export_range(0, 60) var timer: int = 30
@export var show_hiscore: bool = true
@export var score_style: ScoreTypes = ScoreTypes.EXPLICIT_TEXT


func _process(delta):
	$VBoxContainer/LabelTimer.text = str(round($GameTimer.time_left))
