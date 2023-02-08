extends CanvasLayer

enum TransitionStyles {FADE, CIRCLE, STAR}

var current_scene: Node


func _ready():
	for child in get_tree().get_root().get_children():
		if child is Control and child.is_in_group("BaseScreen"):
			current_scene = child
	$AnimationPlayer.play_backwards("transition_fade")


func transition(in_style: TransitionStyles, in_dark: bool, out_style: TransitionStyles, out_dark: bool, scene: String):
	$CanvasGroup/ColorRect.color = Color.BLACK if in_dark else Color.WHITE
	$AnimationPlayer.play("transition_" + TransitionStyles.keys()[in_style].to_lower())
	if in_style == TransitionStyles.STAR:
		$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished

	if scene != "":
		if current_scene != null:
			current_scene.free()
		current_scene = load(scene).instantiate()
		get_tree().get_root().add_child(current_scene)

	$CanvasGroup/ColorRect.color = Color.BLACK if out_dark else Color.WHITE
	$AnimationPlayer.play_backwards("transition_" + TransitionStyles.keys()[out_style].to_lower())
