extends Control

@onready var sfx: AudioStreamPlayer = $AudioSFX


func _on_button_back_button_down():
	sfx.set_stream(DBs.SOUNDS.quit)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.FADE, true, "%special%quit")


func _on_button_single_button_down():
	sfx.set_stream(DBs.SOUNDS.positive)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, false, "res://menus/single_game_chooser.tscn")


func _on_button_vs_button_down():
	sfx.set_stream(DBs.SOUNDS.positive)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.NONE, Transitionizer.TransitionStyles.NONE, false, "res://menus/fatal_error.tscn")


func _on_button_options_pressed():
	Transitionizer.set_overlay("res://menus/opions_overlay.tscn")


func _on_button_about_pressed():
	sfx.set_stream(DBs.SOUNDS.positive)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.CIRCLE, false, "res://menus/about.tscn")
