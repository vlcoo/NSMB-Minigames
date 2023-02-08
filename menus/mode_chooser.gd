extends Control

@onready var sfx: AudioStreamPlayer = $AudioSFX
var sfx_quit: AudioStream = preload("res://menus/assets/audio/negative.ogg")


func _on_button_back_button_down():
	sfx.set_stream(sfx_quit)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.CIRCLE, Transitionizer.TransitionStyles.FADE, true, "%special%quit")
