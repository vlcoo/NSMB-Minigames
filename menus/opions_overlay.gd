extends Control


func _ready():
	$VBoxTop/ButtonMusicVol/HBoxContainer/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	$VBoxBottom/ButtonSFXVol/HBoxContainer/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_sfx_slider_drag_ended(value_changed):
	$AudioSFX.stream = DBs.SOUNDS.soundmode
	$AudioSFX.play()


func _on_button_continue_button_down():
	$AudioSFX.stream = DBs.SOUNDS.positive
	$AudioSFX.play()
	await $AudioSFX.finished
	Transitionizer.free_current_overlay()
