extends Control


func _ready():
	$VBoxTop/ButtonMusicVol/HBoxContainer/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$VBoxBottom/ButtonSFXVol/HBoxContainer/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_sfx_slider_drag_ended(value_changed):
	$AudioSFX.stream = DBs.SOUNDS.soundmode
	$AudioSFX.play()


func _on_button_continue_button_down():
	SaveSystem.options["music_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	SaveSystem.options["sfx_volume"] = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	SaveSystem.save_options()

	$AudioSFX.stream = DBs.SOUNDS.positive
	$AudioSFX.play()
	await $AudioSFX.finished
	Transitionizer.free_current_overlay()


func _on_button_erase_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$AudioSFX.stream = DBs.SOUNDS.positive
		$AudioSFX.play()
		$VBoxBottom/ButtonErase.text = "Sure?"
	else:
		$AudioSFX.stream = DBs.SOUNDS.negative
		$AudioSFX.play()
		$VBoxBottom/ButtonErase.text = "Done"
		SaveSystem.erase_scoreboards()
		await $AudioSFX.finished
		Transitionizer.free_current_overlay()
