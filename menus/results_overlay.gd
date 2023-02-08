extends Control

enum GameOverTypes {GENERIC, TIME_UP, GOAL}
enum ScoreboardStyles {GENERIC, STARS, TIMES, NONE}

@export var type: GameOverTypes = GameOverTypes.GENERIC
@export var scoreboard_style: ScoreboardStyles = ScoreboardStyles.GENERIC


func _ready():
	appear()


func appear():
	var new_text: String

	match type:
		GameOverTypes.GENERIC:
			new_text = $GameOverTitle.text.replace("%placeholder%", "Game Over")
		GameOverTypes.TIME_UP:
			new_text = $GameOverTitle.text.replace("%placeholder%", "Time's Up")
		GameOverTypes.GOAL:
			new_text = $GameOverTitle.text.replace("%placeholder%", "Goal")

	match scoreboard_style:
		ScoreboardStyles.NONE:
			$ScoreboardTitle.text = ""

	$GameOverTitle.text = new_text
	$AnimationPlayer.play("in")
