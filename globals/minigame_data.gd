extends Resource
class_name MinigameData

enum GameCategories {ACTION, PUZZLE, TABLE, VARIETY}
enum ScoreboardTypes {GENERIC, STARS, TIME, COINS}

@export_category("Minigame Data")
@export var name: String
@export var category: GameCategories
@export var scoreboard_type: ScoreboardTypes
@export var icon: Texture2D
@export var singleplayer: bool = true
@export var multiplayer: bool
@export_multiline var description: String
@export var game_scene: PackedScene

var scoreboard: Dictionary = {
	"Place1": 0,
	"Place2": 0,
	"Place3": 0,
	"Place4": 0,
	"Place5": 0,
	"Coins": 0
}
