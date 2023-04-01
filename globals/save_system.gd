extends Node

var json = JSON.new()


func load_scoreboard(minigame: MinigameData):
	if not FileAccess.file_exists("user://scoreboards/%s.json" % minigame.name):
		return

	var save_game = FileAccess.open("user://scoreboards/%s.json" % minigame.name, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		assert(json.parse(save_game.get_line()) == OK, "Save file is corrupted. " + json.get_error_message())
		var data: Dictionary = json.get_data()
		assert(typeof(data) == TYPE_DICTIONARY, "Save file is corrupted.")
		for key in data.keys():
			minigame.scoreboard[key] = data.get(key)

