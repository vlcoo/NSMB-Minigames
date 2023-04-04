extends Control

@export var company_name: String


func _ready() -> void:
	randomize()
	company_name = get_company_name()

	$BoxContainer/LabelLogo.text = company_name
	$BoxContainer/LabelDetail.text = $BoxContainer/LabelDetail.text.replace("%placeholder%", company_name.to_upper())


func _on_timer_timeout() -> void:
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")


func get_company_name() -> String:
	var c: String = "N"
	c += ["i", "l"][randi() % 2]
	c += ["n", "m"][randi() % 2]
	c += ["i", "t", "l"][randi() % 3]
	c += ["e", "a", "o"][randi() % 3]
	c += ["n", "m"][randi() % 2]
	c += "d" if c != "Ninten" else "t"
	c += ["e", "a", "o"][randi() % 3]

	return c
