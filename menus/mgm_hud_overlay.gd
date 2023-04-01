extends Control

enum ScoreTypes {EXPLICIT_TEXT, STAR_COUNT}
signal time_up
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

@export_range(0, 60) var timer: int = 30
@export var show_hiscore: bool = true
@export var score_style: ScoreTypes = ScoreTypes.EXPLICIT_TEXT

var sfx_countdown_1 = preload("res://menus/assets/audio/countdown_1.ogg")
var sfx_countdown_2 = preload("res://menus/assets/audio/countdown_2.ogg")
var sfx_countdown_depleted = preload("res://menus/assets/audio/countdown_depleted.ogg")

var seconds_left: int


func _ready():
	seconds_left = timer + 1
	if timer > 0: $SecondsTimer.start()
	else: $BoxTimer.visible = false


func _process(delta):
	pass


func _on_seconds_timer_timeout():
	seconds_left -= 1
	$BoxTimer/LabelTimer.text = str(seconds_left)

	if seconds_left == 0:
		sfx.set_stream(sfx_countdown_depleted)
		sfx.play()
	elif seconds_left == -1:
		emit_signal("time_up")
		$SecondsTimer.stop()
	elif 2 < seconds_left and seconds_left < 6:
		sfx.set_stream(sfx_countdown_1)
		sfx.play()
	elif 2 >= seconds_left:
		sfx.set_stream(sfx_countdown_2)
		sfx.play()
