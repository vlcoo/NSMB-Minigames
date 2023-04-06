extends Control

enum GameOverTypes {GENERIC, TIME_UP, GOAL}
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
const BBCODE_SCORE_PULSE: String = "[pulse freq=2.5 ease=1.0 height=0]"
const BBCODE_HIGHSCORE_RAINBOW: String = "[shake rate=12 level=8][center][rainbow freq=0.5 sat=0.8 val=1]"

@export var type: GameOverTypes = GameOverTypes.GENERIC
@export var scoreboard_style: MinigameData.ScoreboardTypes = MinigameData.ScoreboardTypes.GENERIC
@export var show_scorelist: bool = true

var hiscore_sfx = preload("res://common/assets/songs/NCS_BGM_MINIHISCORE.ogg")
var place = -1


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
			MinigameData.ScoreboardTypes.GENERIC, MinigameData.ScoreboardTypes.TIME:
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
	$AnimationPlayer.play("reveal_scorelist")


func check_and_reveal_hiscore():
	if place != 1: return

	sfx.stream = hiscore_sfx
	sfx.play()
	$GameOverTitle.visible = true
	$GameOverTitle/PointLight2D.visible = false
	$GameOverTitle.text = BBCODE_HIGHSCORE_RAINBOW + "High Score"


func calc_and_store_scoreboard(new_score: int):
	if Transitionizer.selected_minigame == null: return

	place = SaveSystem.add_scoreboard_place(Transitionizer.selected_minigame, new_score)
	SaveSystem.save_scoreboard(Transitionizer.selected_minigame)
	$PanelScoreboard/MarginContainer/VBoxContainer/NoTopEntry.visible = place == 6

	if scoreboard_style != MinigameData.ScoreboardTypes.COINS:
		for i in range(1, 6):
			var s_score: String = calc_score_string(Transitionizer.selected_minigame.scoreboard["Place" + str(i)])
			var node = get_node("PanelScoreboard/MarginContainer/VBoxContainer/HBoxContainer" + str(i) + "/LabelScore" + ("Big" if scoreboard_style == MinigameData.ScoreboardTypes.STARS else ""))
			node.text = node.text.replace("%", (BBCODE_SCORE_PULSE if i == place else "") + s_score)
		if place == 6:
			var s_score: String = calc_score_string(new_score)
			var node = get_node("PanelScoreboard/MarginContainer/VBoxContainer/NoTopEntry/LabelScore" + ("Big" if scoreboard_style == MinigameData.ScoreboardTypes.STARS else ""))
			node.text = node.text.replace("%", BBCODE_SCORE_PULSE + s_score)
	else:
		pass


func calc_score_string(score: int) -> String:
	var s_score: String
	if scoreboard_style == MinigameData.ScoreboardTypes.TIME:
		s_score = "%04d" % score
		s_score = s_score.substr(0, 2) + "\"" + s_score.substr(2, 4)
	else: s_score = str(score)
	return s_score


func _on_button_continue_button_down():
	$AnimationPlayer.play("reveal_buttons")


func _on_button_retry_button_down():
	sfx.set_stream(DBs.SOUNDS.positive)
	sfx.play()
	if (Transitionizer.selected_minigame == null): return
	Transitionizer.transition(Transitionizer.TransitionStyles.STAR, Transitionizer.TransitionStyles.STAR, false, Transitionizer.selected_minigame.game_scene)


func _on_button_quit_button_down():
	sfx.set_stream(DBs.SOUNDS.negative)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.CIRCLE, true, "res://menus/single_game_chooser.tscn")
