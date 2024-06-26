extends Control

@onready var sfx: AudioStreamPlayer = $AudioSFX


func _ready():
	for minigame in $ContainerGames.get_meta("AvailableGames"):
		assert(minigame is MinigameData, "ContainerGames' minigame array contains object that's not a MinigameData.")
		var button = TextureButton.new()
		button.texture_normal = minigame.icon
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER + Control.SIZE_EXPAND
		$ContainerGames.add_child(button)
		button.button_down.connect(_on_button_minigame_pressed.bind(minigame, button))
		button.focus_mode = Control.FOCUS_NONE
		button.add_to_group(MinigameData.GameCategories.keys()[minigame.category])

	change_category(Transitionizer.selected_category)
	Transitionizer.selected_minigame = null


func change_category(category: MinigameData.GameCategories, silently: bool = true):
	assert(category >= 0 and category < MinigameData.GameCategories.size(), "Tried to load a non-existent minigame category.")
	
	Transitionizer.selected_category = category
	var category_name = MinigameData.GameCategories.keys()[category]

	for button_game in $ContainerGames.get_children():
		button_game.visible = category_name in button_game.get_groups()

	if not silently:
		$PanelDescription/Label.text = DBs.CATEGORY_DESCRIPTIONS[category];
		sfx.set_stream(DBs.SOUNDS.cursor)
		sfx.play()
	else:
		$ContainerCategories.get_node(category_name.capitalize()).button_pressed = true


func _on_button_back_button_down():
	sfx.set_stream(DBs.SOUNDS.negative)
	sfx.play()
	Transitionizer.transition(Transitionizer.TransitionStyles.FADE, Transitionizer.TransitionStyles.FADE, true, "res://menus/mode_chooser.tscn")


func _on_button_minigame_pressed(minigame: MinigameData, button):
	button.modulate = Color(1.2, 1.2, 0.3, 1)
	Transitionizer.transition(Transitionizer.TransitionStyles.STAR, Transitionizer.TransitionStyles.STAR, false, "res://menus/minigame_description.tscn")
	Transitionizer.selected_minigame = minigame
