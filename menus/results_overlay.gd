extends Control

enum GameOverTypes {GENERIC, TIME_UP, GOAL}

@export var type: GameOverTypes = GameOverTypes.GENERIC
@export var scoreboard_style: MinigameData.ScoreboardTypes = MinigameData.ScoreboardTypes.GENERIC
@export var show_scorelist: bool = true


func _ready():
	pass


func appear():
	var new_text: String
	match type:
		GameOverTypes.GENERIC:
			new_text = "Game Over"
		GameOverTypes.TIME_UP:
			new_text = "Time's Up"
		GameOverTypes.GOAL:
			new_text = "Goal"
	$GameOverTitle.text = $GameOverTitle.text.replace("%placeholder%", new_text)

	if not show_scorelist:
		$ScoreboardTitle.text = ""
	else:
		match scoreboard_style:
			[MinigameData.ScoreboardTypes.GENERIC, MinigameData.ScoreboardTypes.TIME]:
				for child in get_tree().get_nodes_in_group("ScoreboardEntry"):
					child.get_node("LabelStarhint").visible = false
					child.get_node("LabelScoreBig").visible = false
					child.get_node("LabelScore").visible = true
			MinigameData.ScoreboardTypes.STARS:
				for child in get_tree().get_nodes_in_group("ScoreboardEntry"):
					child.get_node("LabelStarhint").visible = true
					child.get_node("LabelScoreBig").visible = true
					child.get_node("LabelScore").visible = false
			MinigameData.ScoreboardTypes.COINS:
				pass

	$AnimationPlayer.play("in")
	await $AnimationPlayer.animation_finished
	if show_scorelist:
		reveal_scorelist()
	else:
		# FIXME: complete transition to menu??
		Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.CIRCLE, true, "res://menus/single_game_chooser.tscn")


func reveal_scorelist():
	# TODO: reveal animation
	pass
