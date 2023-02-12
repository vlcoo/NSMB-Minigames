extends Node

const SOUNDS: Dictionary = {
	"quit": preload("res://menus/assets/audio/quit.ogg"),
	"positive": preload("res://menus/assets/audio/positive.ogg"),
	"negative": preload("res://menus/assets/audio/negative.ogg"),
	"cursor": preload("res://menus/assets/audio/cursor.ogg"),
	"pause": preload("res://menus/assets/audio/pause.ogg"),
	"soundmode": preload("res://menus/assets/audio/soundmode.ogg"),
	"advance": preload("res://menus/assets/audio/advance.ogg"),
	"transition_star": preload("res://common/assets/audio/star_transition.ogg")
}

const CATEGORY_DESCRIPTIONS: Dictionary = {
	MinigameData.GameCategories.ACTION: "Choose Action to play games that\nrely on your skill with the touchscreen or mouse.",
	MinigameData.GameCategories.PUZZLE: "If you think you’ve got a big brain,\nPuzzle games are the choice for you!",
	MinigameData.GameCategories.TABLE: "If you like Table games, this is the\nchoice for you!",
	MinigameData.GameCategories.VARIETY: "If you want to pick from a wide\narray of games, just choose Variety!",
}
