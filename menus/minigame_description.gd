extends Control


func _ready():
	if Transitionizer.selected_minigame != null:
		$PanelTitle/Label.text = Transitionizer.selected_minigame.name
		$PanelDescription/MarginContainer/Label.text = Transitionizer.selected_minigame.description

	if Transitionizer.selected_minigame != null:
		load_scoreboard(Transitionizer.selected_minigame)


func load_scoreboard(minigame: MinigameData):
	SaveSystem.load_scoreboard(minigame)
	set_scoreboard_style(minigame.scoreboard_type)

	match minigame.scoreboard_type:
		MinigameData.ScoreboardTypes.GENERIC, MinigameData.ScoreboardTypes.STARS:
			for i in range(1, 6):
				get_node("PanelScoreboard/MarginContainer/VBoxContainer/HBoxContainer%d/LabelScore" % i).text = str(minigame.scoreboard["Place" + str(i)])
		MinigameData.ScoreboardTypes.TIME:
			for i in range(1, 6):
				get_node("PanelScoreboard/MarginContainer/VBoxContainer/HBoxContainer%d/LabelScore" % i).text = str(minigame.scoreboard["Place" + str(i)]) + "\"" + str(minigame.scoreboard["Place" + str(i) + "MSeconds"])
		MinigameData.ScoreboardTypes.COINS:
			$PanelCoincount/MarginContainer/VBoxContainer/HBoxContainer/LabelScore.text = str(minigame.scoreboard["Coins"])


func set_scoreboard_style(style: MinigameData.ScoreboardTypes):
	match style:
		MinigameData.ScoreboardTypes.GENERIC, MinigameData.ScoreboardTypes.TIME:
			for child in get_tree().get_nodes_in_group("ScoreboardEntry"):
				child.get_node("LabelStarhint").visible = false
		MinigameData.ScoreboardTypes.STARS:
			for child in get_tree().get_nodes_in_group("ScoreboardEntry"):
				child.get_node("LabelStarhint").visible = true
		MinigameData.ScoreboardTypes.COINS:
			$PanelScoreboard.visible = false
			$PanelCoincount.visible = true


func _on_button_back_button_down():
	$AudioSFX.stream = DBs.SOUNDS.negative
	$AudioSFX.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/single_game_chooser.tscn")


func _on_button_start_button_down():
	if Transitionizer.selected_minigame != null:
		Transitionizer.transition(Transitionizer.TransitionStyles.STAR, Transitionizer.TransitionStyles.STAR, false, Transitionizer.selected_minigame.game_scene)
