extends Control


func _on_button_back_pressed():
	$AudioSFX.set_stream(DBs.SOUNDS.negative)
	$AudioSFX.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")


func _on_label_meta_clicked(meta):
	$AudioSFX.set_stream(DBs.SOUNDS.advance)
	$AudioSFX.play()
	OS.shell_open(meta)
