extends Resource
class_name MinigameData

enum GameCategories {ACTION, PUZZLE, TABLE, VARIETY}

@export_category("Minigame Data")
@export var name: String
@export var category: GameCategories
@export var icon: Texture2D
@export var singleplayer: bool = true
@export var multiplayer: bool
@export_multiline var description: String
@export var game_scene: PackedScene
