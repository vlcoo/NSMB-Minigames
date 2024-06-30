extends Control

enum ScoreTypes {EXPLICIT_TEXT, STAR_COUNT}
enum GameStates {STALLING, INTRO, PLAYING, PAUSED, GAMEOVER}
signal time_up
signal intro_finished
@onready var sfx_timer: AudioStreamPlayer = $SFXTimer
@onready var sfx_points: AudioStreamPlayer = $SFXPoints

@export_range(0, 60) var timer: int = 30
@export var show_hiscore: bool = true
@export var have_countdown: bool = true
@export var score_style: ScoreTypes = ScoreTypes.EXPLICIT_TEXT
@export var timer_bonus_on_scored: int = 0
## Will be set to 0 if score style is not explicit text
@export var auto_score_increase: int = 0

var sfx_countdown_1 = preload("res://common/assets/audio/countdown_1.ogg")
var sfx_countdown_2 = preload("res://common/assets/audio/countdown_2.ogg")
var sfx_countdown_depleted = preload("res://common/assets/audio/countdown_depleted.ogg")
var sfx_point = preload("res://common/assets/audio/point_singular.ogg")

var seconds_left: int
var points: float = 0
var hiscore: int
var current_state: GameStates = GameStates.STALLING:
	set(v):
		current_state = v
		$SecondsTimer.paused = current_state != GameStates.PLAYING


func _ready():
	seconds_left = timer
	$BoxTimer/LabelTimer.text = str(seconds_left)
	
	if score_style == ScoreTypes.EXPLICIT_TEXT:
		$BoxStars.visible = false
		if Transitionizer.selected_minigame != null: 
			hiscore = Transitionizer.selected_minigame.scoreboard.get("Place1")
			$BoxScoreBar/LabelHiScore.text = str(hiscore)
	elif score_style == ScoreTypes.STAR_COUNT:
		$BoxScoreBar.visible = false
		auto_score_increase = 0

	if timer > 0: $SecondsTimer.start()
	else: $BoxTimer.visible = false
	
	if Transitionizer.is_transitioning:
		await Transitionizer.transition_finished
	if have_countdown: 
		$AnimationPlayer.play(&"intro_countdown")
		current_state = GameStates.INTRO
	else:
		current_state = GameStates.PLAYING
		intro_finished.emit()


func _process(delta):
	if auto_score_increase > 0 and current_state == GameStates.PLAYING:
		points += auto_score_increase * delta
		$BoxScoreBar/LabelScore.text = str(int(points))
		$BoxScoreBar/LabelHiScore.text = str(int(max(hiscore, points)))


func _on_seconds_timer_timeout():
	seconds_left -= 1
	$BoxTimer/LabelTimer.text = str(seconds_left)

	if seconds_left == 0:
		current_state = GameStates.GAMEOVER
		sfx_timer.set_stream(sfx_countdown_depleted)
		sfx_timer.play()
	elif seconds_left == -1:
		emit_signal("time_up")
		$SecondsTimer.stop()
		$BoxTimer.visible = false
	elif 2 < seconds_left and seconds_left < 6:
		sfx_timer.set_stream(sfx_countdown_1)
		sfx_timer.play()
	elif 2 >= seconds_left:
		sfx_timer.set_stream(sfx_countdown_2)
		sfx_timer.play()


func _on_points_sum_specific(how_much: int):
	points += how_much
	if points < 0: points = 0
	$BoxScoreBar/LabelScore.text = str(points)
	$BoxScoreBar/LabelHiScore.text = str(max(hiscore, points))


func _update_star_collection_count():
	$BoxStars/CollectionBG/LabelScore.text = str(points)


func _on_point_gotten():
	points += 1

	match score_style:
		ScoreTypes.EXPLICIT_TEXT:
			$BoxScoreBar/LabelScore.text = str(points)
			$BoxScoreBar/LabelHiScore.text = str(max(hiscore, points))
		ScoreTypes.STAR_COUNT:
			if $"BoxStars/4thStar".visible:
				$AnimationPlayer.play("collect_points")
				return
			for i in range(5):
				if $BoxStars.get_child(i).visible:
					sfx_points.set_stream(sfx_point)
					sfx_points.play()
					$BoxStars.get_child(i-1).visible = true
