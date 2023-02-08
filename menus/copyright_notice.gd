extends Control


func _on_timer_timeout():
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")
