extends Control

@onready var sfx: AudioStreamPlayer = $AudioSFX


func _ready():
	print($GridContainer/DrawTrampoline.get_meta("a").waluigi)


func _on_button_back_button_down():
	sfx.set_stream(DBs.sounds.negative)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")
