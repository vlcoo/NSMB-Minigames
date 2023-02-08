extends Control

@onready var sfx: AudioStreamPlayer = $AudioSFX


func _on_button_back_button_down():
	sfx.set_stream(DBs.sounds.quit)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.FADE, true, "%special%quit")


func _on_button_single_button_down():
	sfx.set_stream(DBs.sounds.positive)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, false, "res://menus/single_game_chooser.tscn")


func _on_button_vs_button_down():
	sfx.set_stream(DBs.sounds.positive)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.NONE, Transitionizer.TransitionStyles.NONE, false, "res://menus/fatal_error.tscn")
