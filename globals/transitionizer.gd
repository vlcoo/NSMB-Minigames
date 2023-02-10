extends CanvasLayer

enum TransitionStyles {FADE, CIRCLE, STAR, NONE}

var current_scene: Node
var current_overlay: Node


func _ready():
	for child in get_tree().get_root().get_children():
		if child is Control and child.is_in_group("BaseScreen"):
			current_scene = child
	$AnimationPlayer.play_backwards("transition_fade")


func transition(in_style: TransitionStyles, out_style: TransitionStyles, dark: bool, scene: String):
	$CanvasGroup/ColorRect.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	$CanvasGroup/ColorRect.color = Color.BLACK if dark else Color.WHITE
	create_tween().tween_method(_set_fadeable_music_db, 0, -25, 0.8).set_ease(Tween.EASE_IN)
	$AnimationPlayer.play("transition_" + TransitionStyles.keys()[in_style].to_lower())
	if in_style == TransitionStyles.STAR:
		$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished

	free_current_overlay()
	if scene.begins_with("%special%"):
		_do_special_command(scene.split("%")[2])
	elif scene != "":
		if current_scene != null:
			current_scene.free()
		current_scene = load(scene).instantiate()
		get_tree().get_root().add_child(current_scene)

	$CanvasGroup/ColorRect.color = Color.BLACK if dark else Color.WHITE
	_set_fadeable_music_db(0)
	$AnimationPlayer.play_backwards("transition_" + TransitionStyles.keys()[out_style].to_lower())
	await $AnimationPlayer.animation_finished
	$CanvasGroup/ColorRect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)


func set_overlay(scene: String):
	free_current_overlay()

	current_overlay = load(scene).instantiate()
	get_tree().get_root().add_child(current_overlay)


func free_current_overlay():
	if current_overlay != null:
		current_overlay.queue_free()
		current_overlay = null


func _set_fadeable_music_db(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FadeableMusic"), value)


func _do_special_command(which: String):
	match which:
		"quit":
			get_tree().quit()
