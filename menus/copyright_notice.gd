extends Control


func _on_timer_timeout():
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, true, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")
