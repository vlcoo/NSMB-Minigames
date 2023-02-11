extends Control


func _ready():
	if Transitionizer.selected_minigame != null:
		$PanelTitle/Label.text = Transitionizer.selected_minigame.name
		$PanelDescription/MarginContainer/Label.text = Transitionizer.selected_minigame.description


func _on_button_back_button_down():
	$AudioSFX.stream = DBs.SOUNDS.negative
	$AudioSFX.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/single_game_chooser.tscn")


func _on_button_start_button_down():
	if Transitionizer.selected_minigame != null:
		Transitionizer.transition(Transitionizer.TransitionStyles.STAR, Transitionizer.TransitionStyles.STAR, false, Transitionizer.selected_minigame.game_scene)
