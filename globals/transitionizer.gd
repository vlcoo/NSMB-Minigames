extends CanvasLayer

enum TransitionStyles {FADE, CIRCLE, STAR, NONE}

@onready var sfx = $AudioStreamPlayer
var current_scene: Node
var current_overlay: Node
var is_transitioning := false

var selected_minigame: MinigameData
var selected_category: MinigameData.GameCategories = MinigameData.GameCategories.ACTION

@onready var texture_star: TextureRect = $TextureStar
@onready var texture_circle: TextureRect = $TextureCircle
@onready var texture_blank: ColorRect = $TextureBlank

signal transition_finished


func _ready():
	for child in get_tree().get_root().get_children():
		if child.is_in_group("BaseScreen"):
			current_scene = child
	$AnimationPlayer.play_backwards("transition_fade")


func transition(in_style: TransitionStyles, out_style: TransitionStyles, dark: bool, path_or_scene):
	assert(not is_transitioning, "Tried to transition to a new scene while already in the middle of one!")
	
	# TODO: fix mask and re-enable the rest of the transitions.
	var needs_star_sfx = in_style == TransitionStyles.STAR
	if in_style != TransitionStyles.NONE: in_style = TransitionStyles.FADE
	if out_style != TransitionStyles.NONE: out_style = TransitionStyles.FADE
	
	var scene: String
	if path_or_scene != null:
		scene = path_or_scene.resource_path if path_or_scene is PackedScene else path_or_scene
	assert(scene != null and (scene.begins_with("%special%") or ResourceLoader.exists(str(scene))), "Tried to transition into non-existent Scene.")
	is_transitioning = true

	texture_blank.set_mouse_filter(Control.MOUSE_FILTER_STOP)
	texture_blank.color = Color.BLACK if dark else Color.WHITE
	var tween = create_tween()
	tween.tween_method(_set_fadeable_music_volume, 1.0, 0.15, 0.6).set_ease(Tween.EASE_IN)
	$AnimationPlayer.play("transition_" + TransitionStyles.keys()[in_style].to_lower())
	if in_style == TransitionStyles.STAR or needs_star_sfx:
		sfx.play()
	await $AnimationPlayer.animation_finished
	if tween.is_running(): await tween.finished

	free_current_overlay()
	DBs.free_preloads()
	if scene.begins_with("%special%"):
		_do_special_command(scene.split("%")[2])
	elif scene != "":
		if current_scene != null:
			current_scene.free()
		current_scene = load(scene).instantiate()
		get_tree().get_root().add_child(current_scene)

	texture_blank.color = Color.BLACK if dark else Color.WHITE
	_set_fadeable_music_volume(1.0)
	$AnimationPlayer.play_backwards("transition_" + TransitionStyles.keys()[out_style].to_lower())
	await $AnimationPlayer.animation_finished
	texture_blank.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	is_transitioning = false
	transition_finished.emit()


func set_overlay(scene: String):
	free_current_overlay()

	current_overlay = load(scene).instantiate()
	get_tree().get_root().add_child(current_overlay)


func free_current_overlay():
	if current_overlay != null:
		current_overlay.queue_free()
		current_overlay = null


func raise_fatal_error(custom_message: String = "", return_scene_override: String = "") -> void:
	current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.stop()
	is_transitioning = false
	await get_tree().create_timer(1).timeout
	set_overlay("res://menus/fatal_error_overlay.tscn" if not return_scene_override else return_scene_override)


func _set_fadeable_music_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FadeableMusic"), linear_to_db(value))


func _do_special_command(which: String):
	match which:
		"quit":
			get_tree().quit()
