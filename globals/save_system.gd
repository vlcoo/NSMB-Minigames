extends Node

var json = JSON.new()

var options: Dictionary = {
	"music_volume": -1.0,
	"sfx_volume": -1.0
}

func _ready() -> void:
	load_options()


func save_options():
	var config = ConfigFile.new()
	for option in options:
		config.set_value("LocalSettings", option, options[option])
	config.save("user://savedata.ini")


func load_options():
	var config = ConfigFile.new()
	if config.load("user://savedata.ini") != OK:
		return

	for option in options:
		options[option] = config.get_value("LocalSettings", option)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), options["music_volume"])
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), options["sfx_volume"])


func erase_scoreboards():
	OS.move_to_trash(ProjectSettings.globalize_path("user://scoreboards/"))


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


func save_scoreboard(minigame: MinigameData):
	if not FileAccess.file_exists("user://scoreboards"):
		DirAccess.make_dir_absolute("user://scoreboards")

	var save_game = FileAccess.open("user://scoreboards/%s.json" % minigame.name, FileAccess.WRITE)
	save_game.store_line(JSON.stringify(minigame.scoreboard))


func add_scoreboard_place(to_which: MinigameData, new_score: int) -> int:
	if to_which.scoreboard_type != MinigameData.ScoreboardTypes.COINS:
		var places: Array = []
		for place in to_which.scoreboard.keys():
			if place.begins_with("Place"): places.append(to_which.scoreboard.get(place))
		places.append(new_score)
		places.sort()
		places.reverse()
		places.remove_at(places.size()-1)
		var place_id = places.find(new_score)
		for i in places.size():
			to_which.scoreboard["Place" + str(i+1)] = places[i]
		return 6 if (place_id == -1 or new_score <= 0) else place_id + 1

	else:
		return -1
