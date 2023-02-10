extends Control

@export var company_name: String = "Natninda"


func _ready():
	$BoxContainer/LabelLogo.text = company_name
	$BoxContainer/LabelDetail.text = $BoxContainer/LabelDetail.text.replace("%placeholder%", company_name.to_upper())


func _on_timer_timeout():
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")
